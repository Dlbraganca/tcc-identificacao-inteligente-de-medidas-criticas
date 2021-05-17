#include"./headers/a_search_dc.h"


	a_search_dc::a_search_dc() {};
	
	a_search_dc::a_search_dc(const char* CK_PARAM_FILE) : ck_search(CK_PARAM_FILE)
	{	
		search();
		report();
	};

	a_search_dc::~a_search_dc() {};
	
	//systemState a_search_dc::get_result() {
	//	return result;
	//}
	
	bool comparar_heuristicas_dc(systemState& a, systemState& b) {
		return a.get_heuristic() < b.get_heuristic(); //crescente
	};

	void sort_vector_dc(std::vector<systemState>& x) {
		std::sort(x.begin(), x.end(), &comparar_heuristicas_dc);
	};

	std::vector<unsigned int> a_search_dc::convert_measurements() {
		//retira os medidores com erros grosseiros da rede ex: 0 0 0 1 1 0 0 (1) medidas retiradas
		std::vector<unsigned int> auxMeasurement = critical_data.get_measurement();
		std::vector<unsigned int> resultVector(critical_data.get_nm(), 0);
		std::vector<std::vector<unsigned int>> hPosition = critical_data.get_h_position();
		std::vector < std::vector<unsigned int>> pair = critical_data.get_pair();
		// para medidas reais
		for (size_t i = 0; i < auxMeasurement.size(); i++)
		{
			for (size_t j = 0; j < hPosition.size(); j++)
			{
				if (auxMeasurement[i] == hPosition[j][0])
				{
					unsigned int position = hPosition[j][1] - 1;
					resultVector[position] = 1;
				}
			}
		}
		// para medidas img
		for (size_t i = 0; i < auxMeasurement.size(); i++)
		{
			for (size_t k = 0; k < pair.size(); k++)
			{
				if (pair[k][0] !=0 && pair[k][1] == auxMeasurement[i])
				{
					unsigned int aux = pair[k][0];
					for (size_t j = 0; j < hPosition.size(); j++)
					{
						if (aux == hPosition[j][0])
						{
							unsigned int position = hPosition[j][1] - 1;
							resultVector[position] = 1;
						}
					}
				}
			}
		}
		return resultVector;
		//
	};

	std::string a_search_dc::hash_key(std::vector<unsigned int> x) {
		std::string result;
		for (size_t i = 0; i < x.size(); i++)
		{
			result.push_back(x[i]);
		}
		return result;
	}

	void a_search_dc::search() {

		//o vetor inicial é definido retirando todas as medidas com EGs da rede 
		std::vector<unsigned int> initialVector = convert_measurements();
		//a busca vai procurar o conjunto que seja possível uma rede observável com a maior soma de RN
		systemState current = systemState(initialVector, critical_data, critical_data.get_param()); //define a corrente como estado inicial
		std::unordered_map<std::string, bool> temporaryMap;
		elapsed_time = clock();
		std::vector<systemState> pile; //pilha de estados
		pile.push_back(current); //adiciona atual na pilha 
		while (!pile.empty()) //inicia a busca
		{
			current = pile.back(); // o proximo na pilha se torna o atual
			pile.pop_back(); //tira a da pilha
			if (critical_data.measurement_criticality(current.get_cklist()) == 0) //verifica se é o objetivo
			{
				lopt.push(current.get_cklist());
				break; // se for termina a busca 
			}
			else { // se nao for 
				no_of_visited_solutions++;
				std::vector<unsigned int> state = current.get_cklist();
				for (size_t i = 0; i < state.size(); i++) //expande os estados 
				{
					if (state[i] == 1) // adiciona a medida retirada 
					{
						std::vector<unsigned int> newState = state;
						newState[i] = 0;
						std::string hashKey = hash_key(newState);
						if (temporaryMap.find(hashKey) == temporaryMap.end())
						{
							pile.push_back(systemState(newState, critical_data, critical_data.get_param()));
							temporaryMap.emplace(hashKey, true);
						}
					}
				}
			}
			sort_vector_dc(pile);
			
			//std::cout << "ordena---------------\n";
			//for (unsigned int i = 0; i < pile.size(); i++)
			//{
			//	std::cout << pile[i].get_heuristic() << std::endl;
			//}
		}
		//std::cout << "\nTEMPO MEDIO DE ITERACAO: " << tend / contador << std::endl;
		//std::cout << "TEMPO TOTAL DE EXECUCAO: " << tend << std::endl;
		//std::cout << "NUMERO DE ITERACOES: " << contador << std::endl;
		//std::cout << "MEMORIA UTILIZADA: " << get_memory() << std::endl;
		elapsed_time = clock() - elapsed_time;
	}

	void a_search_dc::report() {

		std::ofstream critfile, report_file;
		std::vector<unsigned int> tuple;
		int result;

		critfile.open("critical_tuples.txt", std::ios::trunc);
		report_file.open("BB_report.txt");
		if (report_file.is_open()) { // impressao parametros do problema
			report_file << "Parametros do problema \n" << std::endl;
			//report_file << "Dimensao:" << dim << std::endl;
			//report_file << "k-limite:" << klim << std::endl;
			//report_file << "k-min:" << kmin << std::endl;
			//report_file << "k-max:" << kmax << std::endl;
			//report_file << "Criticalidade:" << get_crit_type() << std::endl;
			report_file << "Tipo de busca:" << get_search_method() << std::endl;
			report_file << "no. solucoes visitadas:" << no_of_visited_solutions << std::endl;
			report_file << "tempo decorrido:" << elapsed_time << std::endl;
			report_file << "memória utilizada:" << get_memory() << std::endl;
		}
		//if (critfile.is_open()) { // impressao das tuplas criticas
		//	while (!lopt.empty()) {
		//		tuple = lopt.top(); // get stack top element		
		//		lopt.pop(); // pop stack
		//		for (std::vector<unsigned int>::iterator it = tuple.begin(); it != tuple.end(); ++it) {
		//			critfile << *it << " ";
		//		}
		//		critfile << std::endl;
		//	}
		//	critfile.close();
		//	std::cout << "critical tuples file successfully generated !!!!" << std::endl;
		//}
		if (critfile.is_open()) { // impressao das tuplas criticas
			while (!lopt.empty()) {
				tuple = lopt.top(); // get stack top element		
				lopt.pop(); // pop stack
				for (unsigned int i = 0; i < tuple.size(); i++) {
					if (tuple[i] == 1)
					{
						critfile << i + 1 << "\n"; //printa a medida real
						std::vector < std::vector<unsigned int>> pair = critical_data.get_pair(); // recebe a matriz dos pares
						for (size_t j = 0; j < pair.size(); j++) //procura se existe imaginario
						{
							if (i + 1 == pair[j][0])
							{
								critfile << pair[j][2] << "\n"; //printa a medida imag
							}
						}
					}
				}
				critfile << std::endl;
			}
			critfile.close();
			std::cout << "critical tuples file successfully generated !!!!" << std::endl;
		}
		else
		{
			std::cout << "Unable to print the critical tuples" << std::endl;
		}
		result = remove("active_subsets.temp");// limpeza dos arquivos temporarios
		result = remove("critical_list.temp");// limpeza dos arquivos temporarios
		result = remove("temp_report.temp");// limpeza dos arquivos temporarios
	};