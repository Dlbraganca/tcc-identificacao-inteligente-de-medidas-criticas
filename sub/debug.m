function debug(A, DBG)
if DBG
    if issparse(A)
        full (A)
    else
        A
    end
end
