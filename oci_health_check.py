import oci
import paramiko
import pytz
import re
from datetime import datetime, timezone, timedelta

SSH_USER           = "opc"
SSH_KEY            = "C:/Users/Pranshu/.ssh/id_rsa"
USE_PUBLIC_IP      = True
ANNOUNCEMENTS_DAYS = 7
TIMEZONE           = "Asia/Kolkata"
COMMANDS = [
    "uptime -p",
    "grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf \"%.2f%%\\n\", usage}'",
    "df -hT | grep -v tmpfs",
    "free -hw"
]
DISK_WARN  = 70
DISK_CRIT  = 80
MEM_WARN   = 70
MEM_CRIT   = 80
SWAP_WARN  = 10
SWAP_CRIT  = 20


# -- Compute Nodes -------------------------------------------------------------

def get_instances():
    config          = oci.config.from_file()
    identity_client = oci.identity.IdentityClient(config)
    regions         = identity_client.list_region_subscriptions(config["tenancy"]).data

    compartments     = identity_client.list_compartments(config["tenancy"], compartment_id_in_subtree=True).data
    all_compartments = [{"name": "root", "id": config["tenancy"]}] + [{"name": c.name, "id": c.id} for c in compartments]

    result  = {}
    running = []

    for region in regions:
        region_config           = config.copy()
        region_config["region"] = region.region_name
        compute_client          = oci.core.ComputeClient(region_config)
        network_client          = oci.core.VirtualNetworkClient(region_config)

        for compartment in all_compartments:
            try:
                instances = compute_client.list_instances(compartment_id=compartment["id"]).data
                if not instances:
                    continue
                key = f"{region.region_name}/{compartment['name']}"
                print(f"\n=== {key} ===")
                result[key] = []
                for instance in instances:
                    ok = instance.lifecycle_state == "RUNNING"
                    print(f"  {instance.display_name} -> {ok}")
                    result[key].append({"name": instance.display_name, "ok": ok})
                    if ok:
                        ip = get_instance_ip(compute_client, network_client, instance, compartment["id"])
                        if ip:
                            running.append({
                                "name":        instance.display_name,
                                "ip":          ip,
                                "region":      region.region_name,
                                "compartment": compartment["name"]
                            })
            except Exception:
                pass

    return result, running


def get_instance_ip(compute_client, network_client, instance, compartment_id):
    try:
        vnics = compute_client.list_vnic_attachments(compartment_id=compartment_id, instance_id=instance.id).data
        if vnics:
            vnic = network_client.get_vnic(vnics[0].vnic_id).data
            return vnic.public_ip if USE_PUBLIC_IP else vnic.private_ip
    except Exception:
        pass
    return None


# -- SSH -----------------------------------------------------------------------

def ssh_run_commands(ip, commands):
    output = {}
    try:
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        client.connect(ip, username=SSH_USER, key_filename=SSH_KEY, timeout=10)
        print(f"\n--- {ip} ---")
        for cmd in commands:
            _, stdout, stderr = client.exec_command(cmd)
            out = stdout.read().decode().strip()
            err = stderr.read().decode().strip()
            print(f"  $ {cmd}")
            if out:
                print(f"  {out}")
            if err:
                print(f"  ERR: {err}")
            output[cmd] = out or err
        client.close()
    except Exception as e:
        print(f"  SSH failed for {ip}: {e}")
        output["error"] = str(e)
    return output


# -- Load Balancer -------------------------------------------------------------

def get_lb_health():
    config          = oci.config.from_file()
    identity_client = oci.identity.IdentityClient(config)
    regions         = identity_client.list_region_subscriptions(config["tenancy"]).data

    compartments     = identity_client.list_compartments(config["tenancy"], compartment_id_in_subtree=True).data
    all_compartments = [{"name": "root", "id": config["tenancy"]}] + [{"name": c.name, "id": c.id} for c in compartments]

    result = {}

    for region in regions:
        region_config           = config.copy()
        region_config["region"] = region.region_name
        lb_client               = oci.load_balancer.LoadBalancerClient(region_config)

        for compartment in all_compartments:
            try:
                lbs = lb_client.list_load_balancers(compartment_id=compartment["id"]).data
                if not lbs:
                    continue
                key = f"{region.region_name}/{compartment['name']}"
                print(f"\n=== {key} ===")
                result[key] = []
                for lb in lbs:
                    print(f"\n  LB: {lb.display_name} -> {lb.lifecycle_state}")
                    lb_entry     = {"name": lb.display_name, "state": lb.lifecycle_state, "backend_sets": []}
                    backend_sets = lb_client.list_backend_sets(lb.id).data
                    for bs in backend_sets:
                        bs_health = lb_client.get_backend_set_health(lb.id, bs.name).data
                        print(f"    Backend Set: {bs.name} -> {bs_health.status}")
                        bs_entry = {"name": bs.name, "status": bs_health.status, "backends": []}
                        backends = lb_client.list_backends(lb.id, bs.name).data
                        for backend in backends:
                            health = lb_client.get_backend_health(lb.id, bs.name, backend.name).data
                            ok     = health.status == "OK"
                            print(f"      {backend.ip_address}:{backend.port} -> {ok}")
                            bs_entry["backends"].append({"address": f"{backend.ip_address}:{backend.port}", "ok": ok})
                        lb_entry["backend_sets"].append(bs_entry)
                    result[key].append(lb_entry)
            except Exception:
                pass

    return result


# -- IPSec & FastConnect -------------------------------------------------------

def get_connectivity_health():
    config          = oci.config.from_file()
    identity_client = oci.identity.IdentityClient(config)
    regions         = identity_client.list_region_subscriptions(config["tenancy"]).data

    compartments     = identity_client.list_compartments(config["tenancy"], compartment_id_in_subtree=True).data
    all_compartments = [{"name": "root", "id": config["tenancy"]}] + [{"name": c.name, "id": c.id} for c in compartments]

    ipsec_result      = {}
    fastconnect_result = {}

    for region in regions:
        region_config           = config.copy()
        region_config["region"] = region.region_name
        network_client          = oci.core.VirtualNetworkClient(region_config)

        for compartment in all_compartments:
            # -- IPSec --
            try:
                connections = network_client.list_ip_sec_connections(compartment_id=compartment["id"]).data
                if connections:
                    key = f"{region.region_name}/{compartment['name']}"
                    if key not in ipsec_result:
                        ipsec_result[key] = []
                    print(f"\n=== IPSec {key} ===")
                    for conn in connections:
                        print(f"  {conn.display_name} -> {conn.lifecycle_state}")
                        tunnels = network_client.list_ip_sec_connection_tunnels(conn.id).data
                        tunnel_entries = []
                        for t in tunnels:
                            ok = t.lifecycle_state == "AVAILABLE" and t.status == "UP"
                            print(f"    Tunnel {t.display_name or t.id}: state={t.lifecycle_state} status={t.status} routing={t.routing} -> {ok}")
                            tunnel_entries.append({
                                "name":    t.display_name or t.id,
                                "state":   t.lifecycle_state,
                                "status":  t.status,
                                "routing": t.routing,
                                "ok":      ok
                            })
                        ipsec_result[key].append({
                            "name":    conn.display_name,
                            "state":   conn.lifecycle_state,
                            "tunnels": tunnel_entries
                        })
            except Exception:
                pass

            # -- FastConnect --
            try:
                circuits = network_client.list_virtual_circuits(compartment_id=compartment["id"]).data
                if circuits:
                    key = f"{region.region_name}/{compartment['name']}"
                    if key not in fastconnect_result:
                        fastconnect_result[key] = []
                    print(f"\n=== FastConnect {key} ===")
                    for vc in circuits:
                        ok = vc.lifecycle_state == "PROVISIONED" and vc.bgp_session_state == "UP"
                        print(f"  {vc.display_name}: state={vc.lifecycle_state} bgp={vc.bgp_session_state} type={vc.type} -> {ok}")
                        fastconnect_result[key].append({
                            "name":      vc.display_name,
                            "state":     vc.lifecycle_state,
                            "bgp":       vc.bgp_session_state,
                            "type":      vc.type,
                            "bandwidth": vc.bandwidth_shape_name,
                            "ok":        ok
                        })
            except Exception:
                pass

    return ipsec_result, fastconnect_result


# -- Announcements -------------------------------------------------------------

def get_announcements():
    config          = oci.config.from_file()
    identity_client = oci.identity.IdentityClient(config)
    cutoff          = datetime.now(timezone.utc) - timedelta(days=ANNOUNCEMENTS_DAYS)
    regions         = identity_client.list_regions().data

    result = {}
    print("\n=== Announcements ===")

    for region in regions:
        try:
            region_config           = config.copy()
            region_config["region"] = region.name
            ann_client              = oci.announcements_service.AnnouncementClient(region_config)
            announcements           = ann_client.list_announcements(compartment_id=config["tenancy"]).data
            filtered                = [a for a in announcements.items if a.time_one_value and a.time_one_value >= cutoff]

            print(f"\n  {region.name}")
            if not filtered:
                print("    None")
                result[region.name] = []
            else:
                result[region.name] = []
                for a in filtered:
                    print(f"    [{a.announcement_type}] {a.summary}")
                    result[region.name].append({
                        "type":    a.announcement_type,
                        "summary": a.summary,
                        "start":   str(a.time_one_value),
                        "end":     str(a.time_two_value)
                    })
        except Exception:
            pass

    return result


# -- Cloud Guard ---------------------------------------------------------------

def get_cloud_guard_problems():
    config    = oci.config.from_file()
    cg_client = oci.cloud_guard.CloudGuardClient(config)

    print("\n=== Cloud Guard Problems ===")
    result = []
    try:
        problems = cg_client.list_problems(
            compartment_id=config["tenancy"],
            compartment_id_in_subtree=True,
            access_level="ACCESSIBLE"
        ).data

        if not problems.items:
            print("  None")
        else:
            for p in problems.items:
                print(f"  [{p.risk_level}] {p.resource_name} - {p.detector_rule_id} -> {p.lifecycle_state}")
                result.append({
                    "risk":     p.risk_level,
                    "resource": p.resource_name,
                    "detector": p.detector_rule_id,
                    "state":    p.lifecycle_state
                })
    except Exception as e:
        print(f"  Error: {e}")

    return result


# -- HTML Helpers --------------------------------------------------------------

def to_mb(val):
    val = val.strip()
    num = float(re.sub(r'[^\d.]', '', val))
    if   'Ti' in val or ('T' in val and 'i' not in val): num *= 1024 * 1024
    elif 'Gi' in val or ('G' in val and 'i' not in val): num *= 1024
    elif 'Ki' in val or ('K' in val and 'i' not in val): num /= 1024
    return num


def render_df(output):
    lines   = output.strip().splitlines()
    content = ""
    for line in lines:
        escaped = line.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
        parts   = line.split()
        bg      = ""
        try:
            use_pct = int(parts[5].replace("%", ""))
            if use_pct >= DISK_CRIT:
                bg = "#ffd0d0"
            elif use_pct >= DISK_WARN:
                bg = "#fff3cd"
        except Exception:
            pass
        if bg:
            content += f'<span style="background:{bg};display:block">{escaped}</span>'
        else:
            content += f"{escaped}\n"
    return f'<pre style="margin:0;white-space:pre;font-family:monospace;font-size:0.85em">{content}</pre>'


def render_free(output):
    lines   = output.strip().splitlines()
    content = ""
    for line in lines:
        escaped = line.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
        parts   = line.split()
        bg      = ""
        try:
            if parts[0].lower().startswith("mem"):
                total = to_mb(parts[1])
                used  = to_mb(parts[2])
                pct   = (used / total) * 100 if total else 0
                if pct >= MEM_CRIT:   bg = "#ffd0d0"
                elif pct >= MEM_WARN: bg = "#fff3cd"
            elif parts[0].lower().startswith("swap"):
                total = to_mb(parts[1])
                used  = to_mb(parts[2])
                pct   = (used / total) * 100 if total else 0
                if pct >= SWAP_CRIT:   bg = "#ffd0d0"
                elif pct >= SWAP_WARN: bg = "#fff3cd"
        except Exception:
            pass
        if bg:
            content += f'<span style="background:{bg};display:block">{escaped}</span>'
        else:
            content += f"{escaped}\n"
    return f'<pre style="margin:0;white-space:pre;font-family:monospace;font-size:0.85em">{content}</pre>'


# -- HTML Report ---------------------------------------------------------------

def generate_html_report(instances, ssh_results, lb_results, ipsec_results, fastconnect_results, announcements, cloud_guard_problems):
    tz  = pytz.timezone(TIMEZONE)
    now = datetime.now(timezone.utc).astimezone(tz).strftime("%Y-%m-%d %H:%M:%S %Z")

    # Compute nodes
    rows_instances = ""
    for compartment, nodes in instances.items():
        for node in nodes:
            color = "green" if node["ok"] else "red"
            rows_instances += f"<tr><td>{compartment}</td><td>{node['name']}</td><td style='color:{color}'>{node['ok']}</td></tr>"
            
    CMD_LABELS = {
        COMMANDS[0]: "Uptime",
        COMMANDS[1]: "CPU",
        COMMANDS[2]: "Disk",
        COMMANDS[3]: "Memory & Swap"
    }        

    # SSH
    rows_ssh   = ""
    current_ip = None
    for ip, data in ssh_results.items():
        if current_ip is not None:
            rows_ssh += "<tr><td colspan='5' style='border-top:2px solid #0969da;padding:0;height:2px'></td></tr>"
        current_ip = ip
        for cmd, out in data["commands"].items():
            label = CMD_LABELS.get(cmd, cmd)
            if "df" in cmd:
                rows_ssh += f"<tr><td>{data['region']}</td><td>{data['name']}</td><td>{ip}</td><td>{label}</td><td>{render_df(out)}</td></tr>"
            elif "free" in cmd:
                rows_ssh += f"<tr><td>{data['region']}</td><td>{data['name']}</td><td>{ip}</td><td>{label}</td><td>{render_free(out)}</td></tr>"
            else:
                rows_ssh += f"<tr><td>{data['region']}</td><td>{data['name']}</td><td>{ip}</td><td>{label}</td><td><pre style='margin:0;font-family:monospace;font-size:0.85em'>{out}</pre></td></tr>"

    # Load balancer
    rows_lb = ""
    for compartment, lbs in lb_results.items():
        for lb in lbs:
            for bs in lb["backend_sets"]:
                for backend in bs["backends"]:
                    color = "green" if backend["ok"] else "red"
                    rows_lb += f"<tr><td>{compartment}</td><td>{lb['name']}</td><td>{bs['name']}</td><td>{backend['address']}</td><td style='color:{color}'>{backend['ok']}</td></tr>"

    # IPSec
    rows_ipsec = ""
    if not ipsec_results:
        rows_ipsec = "<tr><td colspan='6'>None</td></tr>"
    else:
        for compartment, conns in ipsec_results.items():
            for conn in conns:
                if not conn["tunnels"]:
                    rows_ipsec += f"<tr><td>{compartment}</td><td>{conn['name']}</td><td>{conn['state']}</td><td colspan='3'>No tunnels</td></tr>"
                for t in conn["tunnels"]:
                    color = "green" if t["ok"] else "red"
                    rows_ipsec += (
                        f"<tr>"
                        f"<td>{compartment}</td>"
                        f"<td>{conn['name']}</td>"
                        f"<td>{conn['state']}</td>"
                        f"<td>{t['name']}</td>"
                        f"<td>{t['state']} / {t['status']}</td>"
                        f"<td style='color:{color}'>{t['ok']}</td>"
                        f"</tr>"
                    )

    # FastConnect
    rows_fc = ""
    if not fastconnect_results:
        rows_fc = "<tr><td colspan='6'>None</td></tr>"
    else:
        for compartment, vcs in fastconnect_results.items():
            for vc in vcs:
                color = "green" if vc["ok"] else "red"
                rows_fc += (
                    f"<tr>"
                    f"<td>{compartment}</td>"
                    f"<td>{vc['name']}</td>"
                    f"<td>{vc['type']}</td>"
                    f"<td>{vc['bandwidth'] or '-'}</td>"
                    f"<td>{vc['state']} / BGP: {vc['bgp']}</td>"
                    f"<td style='color:{color}'>{vc['ok']}</td>"
                    f"</tr>"
                )

    # Announcements
    rows_ann = ""
    for region, items in announcements.items():
        if not items:
            rows_ann += f"<tr><td>{region}</td><td colspan='3'>None</td></tr>"
        else:
            for a in items:
                rows_ann += f"<tr><td>{region}</td><td>{a['type']}</td><td>{a['summary']}</td><td>{a['start']} - {a['end']}</td></tr>"

    # Cloud guard
    rows_cg = ""
    if not cloud_guard_problems:
        rows_cg = "<tr><td colspan='4'>None</td></tr>"
    else:
        for p in cloud_guard_problems:
            rows_cg += f"<tr><td>{p['risk']}</td><td>{p['resource']}</td><td>{p['detector']}</td><td>{p['state']}</td></tr>"

    html = f"""<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>OCI Health Report</title>
<style>
  body {{ font-family: monospace; background: #ffffff; color: #24292f; padding: 20px; }}
  h1 {{ color: #0969da; }}
  h2 {{ color: #0550ae; border-bottom: 1px solid #d0d7de; padding-bottom: 5px; margin-top: 30px; }}
  table {{ width: 100%; border-collapse: collapse; margin-bottom: 30px; }}
  th {{ background: #f6f8fa; color: #0969da; padding: 8px; text-align: left; }}
  td {{ padding: 8px; border-bottom: 1px solid #d0d7de; vertical-align: top; }}
  tr:hover {{ background: #f6f8fa; }}
  code {{ color: #953800; }}
  .ts {{ color: #57606a; font-size: 0.85em; }}
</style>
</head>
<body>
<h1>OCI Health Report</h1>
<p class="ts">Generated: {now}</p>

<h2>Compute Nodes</h2>
<table><tr><th>Compartment</th><th>Name</th><th>Running</th></tr>{rows_instances}</table>

<h2>SSH Commands</h2>
<table><tr><th>Region</th><th>Node</th><th>IP</th><th>Metric</th><th>Output</th></tr>{rows_ssh}</table>

<h2>Load Balancer Backends</h2>
<table><tr><th>Compartment</th><th>LB</th><th>Backend Set</th><th>Backend</th><th>OK</th></tr>{rows_lb}</table>

<h2>IPSec Tunnels</h2>
<table><tr><th>Compartment</th><th>Connection</th><th>Conn State</th><th>Tunnel</th><th>State / Status</th><th>OK</th></tr>{rows_ipsec}</table>

<h2>FastConnect Virtual Circuits</h2>
<table><tr><th>Compartment</th><th>Name</th><th>Type</th><th>Bandwidth</th><th>State / BGP</th><th>OK</th></tr>{rows_fc}</table>

<h2>Announcements</h2>
<table><tr><th>Region</th><th>Type</th><th>Summary</th><th>Period</th></tr>{rows_ann}</table>

<h2>Cloud Guard Problems</h2>
<table><tr><th>Risk</th><th>Resource</th><th>Detector</th><th>State</th></tr>{rows_cg}</table>

</body>
</html>"""

    filename = datetime.now(timezone.utc).astimezone(tz).strftime("oci_report_%Y-%m-%d_%H-%M-%S.html")
    with open(filename, "w") as f:
        f.write(html)
    print(f"\nReport saved to {filename}")


# -- Main ----------------------------------------------------------------------

if __name__ == "__main__":
    instances, running_instances = get_instances()

    print("\n=== SSH Commands ===")
    ssh_results = {}
    for instance in running_instances:
        ssh_results[instance["ip"]] = {
            "name":        instance["name"],
            "region":      instance["region"],
            "compartment": instance["compartment"],
            "commands":    ssh_run_commands(instance["ip"], COMMANDS)
        }

    lb_results                         = get_lb_health()
    ipsec_results, fastconnect_results = get_connectivity_health()
    announcements                      = get_announcements()
    cloud_guard_problems               = get_cloud_guard_problems()

    generate_html_report(instances, ssh_results, lb_results, ipsec_results, fastconnect_results, announcements, cloud_guard_problems)