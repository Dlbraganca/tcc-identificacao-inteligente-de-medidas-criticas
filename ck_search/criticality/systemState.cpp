#include"./header/systemState.h"


	systemState::systemState() {};
	systemState::~systemState() {};
	systemState::systemState(std::vector<unsigned int> cklist, criticality& critical_data, std::string type) {
		CKLIST = cklist;
		CRITICAL_DATA = critical_data;
		TYPE_SEARCH = type;
		HEURISTIC = measurement_heuristic();
	}


	double systemState::measurement_heuristic() {
		double heuristic = 0;
		std::vector<float> rnValues = CRITICAL_DATA.get_rn();
		std::vector<unsigned int> measurementEGs = CRITICAL_DATA.get_measurement();
		std::vector<std::vector<unsigned int>> hPosition = CRITICAL_DATA.get_h_position();
		std::vector < std::vector<unsigned int>> pair = CRITICAL_DATA.get_pair();
		for (size_t i = 0; i < CKLIST.size(); i++)
		{
			// procura medidas 
			if (CKLIST[i] == 1)
			{
				for (unsigned int j = 0; j < hPosition.size(); j++) //procura pela posicao no jacobiano qual é medida
				{
					if (i + 1 == hPosition[j][1]) // encontrando a medida 
					{
						unsigned int med = hPosition[j][0]; // recebe a medida correspodente do jacobiano
						for (size_t k = 0; k < measurementEGs.size(); k++)
						{
							if (med == measurementEGs[k])
							{
								heuristic = heuristic + rnValues[k];
								break;
							}
						}
						break;
					}
				}
				if (TYPE_SEARCH == "DC") //esse caso so é acessado quando o tipo de busca é DC (para considerar os rn dos EGs)
				{
					for (unsigned int j = 0; j < hPosition.size(); j++) //procura pela posicao no jacobiano qual é medida
					{
						if (i + 1 == hPosition[j][1]) // encontrando a medida 
						{
							unsigned int med = hPosition[j][0]; // recebe a medida correspodente do jacobiano
							for (size_t l = 0; l < pair.size(); l++) // procurar par imaginario correspodente 
							{
								if (med == pair[l][0])
								{
									med = pair[l][1]; //recebe par imag
									for (size_t k = 0; k < measurementEGs.size(); k++) // procura o rn da medida
									{
										if (med == measurementEGs[k]) // encontra a medida na lista de egs
										{
											heuristic = heuristic + rnValues[k]; //adicona o eg na heuristica
										}
									}
								}
							}
						}
					}
				}
			}
		}
		return heuristic;
	}
