
#ifndef HILL_CLIMBING_H
#define HILL_CLIMBING_H
#include<vector>
#include<chrono>
#include<random>
#include<algorithm>
#include<unordered_map>
#include "windows.h"
#include "psapi.h"
#include<stdio.h>
#include<string>
#include"../../criticality/header/ck_search.h"
#include"../../criticality/header/systemState.h"

class A_Search : public ck_search {

public:

	/*inline A_Search(systemState Problem);*/

	A_Search();

	A_Search(const char*);

	~A_Search();

	std::vector<unsigned int> get_result();
	
	/*inline systemState get_result();*/

private:

	//systemState problem;
	
	//systemState result;

	inline systemState highest_value(systemState current);

	void search();

	criticality initial_data;
	ck_search mu_file;
	unsigned int TYPE_SEARCH;
	unsigned int no_of_visited_solutions = 0;
	const char* CK_PARAM_FILE;
	std::stack<std::vector<unsigned int>> lopt;
	std::string param_str;
	systemState bestResult;
	clock_t elapsed_time;
	bool comparar_heuristicas(systemState&, systemState&);
	void sort_vector(std::vector<systemState>&);

	SIZE_T get_memory() {

		PROCESS_MEMORY_COUNTERS_EX pmc;

		GetProcessMemoryInfo(GetCurrentProcess(), (PROCESS_MEMORY_COUNTERS*)&pmc, sizeof(pmc));
		SIZE_T virtualMemUsedByMe = pmc.PrivateUsage;
		SIZE_T physMemUsedByMe = pmc.WorkingSetSize;
		return physMemUsedByMe;
	};
private:
	double bestHeuristic = 100000;
	void report();
	bool check_state(std::vector<unsigned int>);


};
#endif
