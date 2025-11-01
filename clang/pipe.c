#include <stdio.h>
#include <unistd.h>

int main(void)
{
    int pipefd[2]; // array to be passed to the pipe system call.
    int ret1;
    char buffer[16]; // this buffer is where data will be kept in.
    
    pipe(pipefd); // pipe system call is used which will create pipe. pipe will be created with two ends. One for read and next for write end

    ret1 = fork(); // creation of child process through fork is done here. This will now throw two return values.
    // One 0 to a child or one > 0 as for parent, equal to 0 is child.

    if (ret1 > 0) // Part - I of the code
    {
        flush(stdin); // clearing the standard input first.
        printf("\n Parent Process"); // Printing a message as parent.
        write(pipefd[1], "HELLO,MR.SHRI RAM", 16); // writing the contents into Write end of the pipe...i.e. the data is now poured.
    }

    if (ret1 == 0) // Part - II of the code
    {
        sleep(5);
        flush(stdin); // flushing the standard input. It is like a cleaning activity.
        printf("\n This is the child process ");
        read(pipefd[0], buffer, sizeof(buffer)); // data is read, but not issued to display in the screen for that purpose data is kept in buffer and from buffer it can be written to
        write(1, buffer, sizeof(buffer)); // Where 1 represents standard output, the screen.
        return 0;
    }

    return 0;
}
