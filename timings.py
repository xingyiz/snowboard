import csv
import os

timings_file = open("storage/timings.txt", "r")
performance_file = open("snowboard_performance.txt", "w")
programs_dir = "generate/programs/"

# write headers
csv.writer(performance_file).writerow(["test_num", "num_syscalls", "program_size", "time_taken"])

for line in timings_file:
    if line.startswith("concurrent-test"):
        test_num1, test_num2 = line.split("/")[1].split("_")
        if test_num1 == test_num2:
            time_taken = float(line.split("Time taken:")[1])
            program_file = open(programs_dir + test_num1 + ".syz", "r")
            num_syscalls = len(program_file.readlines())
            size = os.path.getsize(programs_dir + test_num1 + ".syz")
            program_file.close()
            csv.writer(performance_file).writerow([test_num1, num_syscalls, size, time_taken])


timings_file.close()
performance_file.close()
