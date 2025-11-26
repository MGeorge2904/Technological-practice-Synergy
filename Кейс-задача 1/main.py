def sum_neg(A: list, N: int) -> int:
    if N < 2:
        return 0
    
    min_i = A.index(min(A))
    max_i = A.index(max(A))
    
    start, end = sorted([min_i, max_i])
    
    return sum(i for i in A[start+1 : end] if i < 0)

print(sum_neg([-10, 2, 10, -8, 1, -10, -5, -100, 10, -20], 10))
