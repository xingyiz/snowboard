#include <stdio.h>
#include <stdlib.h>

#include <sys/mman.h>
#include <sys/time.h>

#include "../ski-hyper.h"
#include "../ski-barriers.h"

extern int STD_SKI_ENABLED, STD_SKI_WAIT_FOR_RESULTS, STD_SKI_CPU_AFFINITY, STD_SKI_HYPERCALLS, STD_SKI_SOFT_EXIT_BARRIER, STD_SKI_USER_BARRIER, STD_SKI_TOTAL_CPUS, STD_SKI_TEST_NUMBER, STD_SKI_PROFILE_ENABLED;
extern int SKI_TEST_COUNTER;
int ski_test_start(int current_cpu, int total_cpus, int dry_run);
void ski_test_finish(int current_cpu, int dry_run);
void hypercall_debug(int current_cpu, char *format, ...);
void hypercall_debug_quiet(int current_cpu, char *format, ...);
extern void ski_trinity_barrier(int current_cpu);
extern void ski_wait_trinity();

int main(){
	
	//printf("Empty for fsstress\n");

	ski_parse_env();

	// To avoid page fault
	//hypercall_debug(STD_SKI_CPU_AFFINITY, (char*)"About to start test [TEST] - CPU: %d Op: %s Op_seed: %d Op_no: %d Op_max: %d Test_seed: %d ",
 	//			STD_SKI_CPU_AFFINITY, "empty", -1, -1, 0, test_seed);

	//hypercall_debug_quiet(STD_SKI_CPU_AFFINITY, (char*)"First call");
	int mlock_parametrs = MCL_CURRENT | MCL_FUTURE;
	if(mlockall(mlock_parametrs) == -1) {
		perror("mlockall failed");
		exit(-2);
	}
	//after the barrier, it could call
	//printf("hahahah passed the barrier\n");

	if (STD_SKI_ENABLED == 1)
		ski_test_start(STD_SKI_CPU_AFFINITY, STD_SKI_TOTAL_CPUS, 1);
	else
		hypercall_debug_quiet(STD_SKI_CPU_AFFINITY, "SKI is disabled and interfaces are not used\n");

    // Actual run
	int ret = -1;
	if (STD_SKI_ENABLED == 1)
    	ret = ski_test_start(STD_SKI_CPU_AFFINITY, STD_SKI_TOTAL_CPUS, 0);
	else
		hypercall_debug_quiet(STD_SKI_CPU_AFFINITY, "SKI is disabled and interfaces are not used\n");

    int test_seed = ret + STD_SKI_CPU_AFFINITY;

	hypercall_debug_quiet(STD_SKI_CPU_AFFINITY, (char*)"Start test [TEST] - CPU: %d Op: %s Op_seed: %d Op_no: %d Op_max: %d Test_seed: %d ",
			STD_SKI_CPU_AFFINITY, "empty", -1, -1, 0, test_seed);

	if (STD_SKI_ENABLED == 1)
    	ski_test_finish(STD_SKI_CPU_AFFINITY,0);
	else
		hypercall_debug_quiet(STD_SKI_CPU_AFFINITY, "SKI is disabled and interfaces are not used\n");

	if (STD_SKI_CPU_AFFINITY==0){
		hypercall_debug_quiet(STD_SKI_CPU_AFFINITY, (char*)"END INFO");
	}

	return 0;
}

