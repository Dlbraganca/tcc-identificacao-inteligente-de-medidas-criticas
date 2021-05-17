#pragma once
#pragma once
#ifndef CRITICALITY_H
#define CRITICALITY_H
#endif
#include <armadillo>
#include <vector>
#include <stack>
#include <algorithm>

class criticality {
private:
	struct readDirective
	{
		std::vector<unsigned int>measur;
		std::vector<float> rn;
		std::vector<std::vector<unsigned int>> jPosition;
		std::vector<std::vector<unsigned int>> measurementPair;
	};
protected:
	std::stack<std::vector<unsigned int>> meas_ck, branch_ck, mu_ck;
	arma::mat H, W, M, A, G, E, U;
	/* H: matriz jacobiano
	G: matriz de ganho
	A: matriz de incidencia ramo-no
	M: matriz incidencia medida-ramo
	E: matriz de covariancia dos residuos
	*/
	std::size_t nm, ns, mu_size;
	std::vector<std::size_t> mu_location, meas_location;
	std::string param_str;
	readDirective EgsValue;

public:
	//double det;
	~criticality();
	criticality();
	criticality(const char*, const char*, const char*, const char*);
	//criticality& operator=(const criticality&) = 0;
	//criticality(const criticality&) =0;
	arma::mat read_matlab_matrix(const char*);
	std::vector<std::vector<unsigned int>> read_parameters(const char*);
	unsigned int  eval_criticality(std::vector<unsigned int>& x, std::string&);
	unsigned int  measurement_criticality(std::vector<unsigned int> x);
	unsigned int  top_branch_criticality(std::vector<unsigned int>& x);
	unsigned int  bd_branch_criticality(std::vector<unsigned int>& x);
	unsigned int  complete_munit_criticality(std::vector<unsigned int>& x);
	unsigned int  munit_observability_analysis(std::vector<unsigned int> y, arma::mat A);
	//unsigned int  observability_analysis(arma::mat, arma::mat, double tol = 1e-10);
	unsigned int  observability_analysis(arma::mat, arma::mat, double tol = 1e-1);
	unsigned int  munit_observability_analysis(std::vector<int>, arma::mat);
	std::size_t get_nm() { return nm; }
	std::size_t get_ns() { return ns; }
	std::size_t get_mu_size() { return mu_size; }
	std::vector<unsigned int> get_measurement() {return EgsValue.measur; }
	std::vector<float> get_rn() { return EgsValue.rn; }
	std::vector < std::vector<unsigned int>> get_h_position() { return EgsValue.jPosition; };
	std::vector < std::vector<unsigned int>> get_pair() { return EgsValue.measurementPair; };
	std::vector<std::size_t> get_mu_location() { return mu_location; }
	std::vector<std::size_t> get_meas_location() { return meas_location; }
	std::string get_param() { return param_str; }
	std::stack<std::vector<unsigned int>> get_meas_ck() { return meas_ck; }
	std::stack<std::vector<unsigned int>> get_mu_ck() { return mu_ck; }
	double get_det() { return arma::det(U); }
};


