//#define USE_FAST_CRITICALITY_H 1
/*#include "criticality.h"
#include "ck_search.h"
#include "bb_ck.h"
*/
#include"./search-methods/headers/a_search.h"
#include"./search-methods/headers/a_search_dc.h"
#include"./search-methods/headers/a_search_pair.h"


void main() {

	std::ifstream parameters_file("ck_directives.txt", std::ios_base::in);
	std::string param_str;
	if (parameters_file.is_open()) {
		std::cout << "Parameter file has been successfully opened. Reading search method ...";
		getline(parameters_file, param_str);
		parameters_file.close();
		std::cout << "Done !!!" << std::endl;
	}
	else
	{
		std::cout << "Unable to open the search parameters file" << std::endl;
	}
	if (param_str.compare("COMPLETE") == 0) {
		A_Search search = A_Search("ck_directives.txt");
	}
	if (param_str.compare("DC") == 0) {
		a_search_dc search = a_search_dc("ck_directives.txt");
	}
	else if (param_str.compare("PAIR") == 0) {
		a_search_pair search = a_search_pair("ck_directives.txt");
	}/*
	else if (param_str.compare("optimized_hillclimbing") == 0) {
		Optimized_HillClimbing search = Optimized_HillClimbing("ck_directives.txt");
	}
	else if (param_str.compare("optimized_dfs") == 0) {
		Optimized_DFS search = Optimized_DFS("ck_directives.txt");
	}
	else if (param_str.compare("reverse_dfs") == 0) {
		reverse_dfs search = reverse_dfs("ck_directives.txt");
	}
	else if (param_str.compare("successive_hill_climbing") == 0) {
		successive_hill_climbing search = successive_hill_climbing("ck_directives.txt");
	}
	else if (param_str.compare("reverse_hill_climbing") == 0) {
		reverse_hill_climbing search = reverse_hill_climbing("ck_directives.txt");
	}*/
};