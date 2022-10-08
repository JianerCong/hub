#include <Rcpp.h>
using namespace Rcpp;

// {{{ Input List

// [[Rcpp::export]]
double mpe(List mod) {
  if (!mod.inherits("lm")) stop("Input must be a linear model");

  NumericVector resid = as<NumericVector>(mod["residuals"]);
  NumericVector fitted = as<NumericVector>(mod["fitted.values"]);

  int n = resid.size();
  double err = 0;
  for(int i = 0; i < n; ++i) {
    err += resid[i] / (fitted[i] + resid[i]);
  }
  return err / n;
}

// }}}

// [[Rcpp::export]]
List outList(){
  List l = List::create( _["a"] = NumericVector(5)
                         );
  return l;

}

// {{{ missing value

// [[Rcpp::export]]
List missing_sampler() {
  return List::create(
                      NumericVector::create(NA_REAL),
                      IntegerVector::create(NA_INTEGER),
                      LogicalVector::create(NA_LOGICAL),
                      CharacterVector::create(NA_STRING)
                      );
}

// }}}
// {{{ return List

// [[Rcpp::export]]
List rleC(NumericVector x) {
  std::vector<int> lengths;
  std::vector<double> values;

  // Initialise first value
  int i = 0;
  double prev = x[0];
  values.push_back(prev);
  lengths.push_back(1);

  NumericVector::iterator it;
  for(it = x.begin() + 1; it != x.end(); ++it) {
    if (prev == *it) {
      lengths[i]++;
    } else {
      values.push_back(*it);
      lengths.push_back(1);

      i++;
      prev = *it;
    }
  }

  return List::create(
                      _["lengths"] = lengths, 
                      _["values"] = values
                      );
}

// }}}
