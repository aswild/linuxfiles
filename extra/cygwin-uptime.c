// cygwin doesn't ship with uptime(1), this file is a simple replacement
// that just parses /proc/uptime and /proc/loadavg to print in the familiar format
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <time.h>
#include <math.h>

#define die(fmt, args...) do { \
        fprintf(stderr, fmt ": %s\n", ##args, strerror(errno)); \
        exit(1); \
    } while (0)

int main()
{
    FILE *fp = fopen("/proc/uptime", "r");
    if (!fp)
        die("Failed to open /proc/uptime");

    float uptime_f;
    int count = fscanf(fp, "%f", &uptime_f);
    fclose(fp);
    if (count != 1)
        die("Failed to parse /proc/uptime");

    const long uptime = lroundf(uptime_f);
    const int days = uptime / 86400;
    const int hours = (uptime % 86400) / 3600;
    const int minutes = ((uptime % 86400) % 3600) / 60;

    char timebuf[32];
    time_t t = time(NULL);
    struct tm *tm = localtime(&t);
    strftime(timebuf, sizeof(timebuf), "%H:%M:%S", tm);

    printf(" %s up ", timebuf);
    if (days)
        printf("%d days, ", days);
    if (hours)
        printf("%d:%02d", hours, minutes);
    else
        printf("%d min", minutes);

    fp = fopen("/proc/loadavg", "r");
    printf(", load average: ");
    if (fp)
    {
        float la1, la2, la3;
        if (fscanf(fp, "%f %f %f", &la1, &la2, &la3) == 3)
            printf("%.2f, %.2f, %.2f", la1, la2, la3);
        else
            printf("[failed to parse /proc/loadavg]");
        fclose(fp);
    }
    else
    {
        printf("[failed to open /proc/loadavg: %s]\n", strerror(errno));
    }

    putchar('\n');
    return 0;
}
