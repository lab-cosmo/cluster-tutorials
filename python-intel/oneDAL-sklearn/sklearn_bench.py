import time
import sklearn.datasets, sklearn.svm

## Data preparation 
digits = sklearn.datasets.load_digits()
X, y = digits.data, digits.target


## Sklearn SVM
print("Standard sklearn SVM comparison:")
clf_sklearn = sklearn.svm.SVC(kernel='rbf', gamma='scale', C =0.5).fit(X, y)
start = time.time()
print("  SVM score:", clf_sklearn.score(X, y)) # output: 0.9905397885364496
end = time.time()
print(f"  Time: {end-start}")


## Intel optimized sklearn SVM using oneDAL
print("Intel optimized sklearn SVM comparison:")
from sklearnex import patch_sklearn
# sklearn is patched
patch_sklearn()
clf_sklearnex = sklearn.svm.SVC(kernel='rbf', gamma='scale', C =0.5).fit(X, y)
start = time.time()
print("  SVM score:", clf_sklearnex.score(X, y)) # output: 0.9905397885364496
end = time.time()
print(f"  Time: {end-start}")
