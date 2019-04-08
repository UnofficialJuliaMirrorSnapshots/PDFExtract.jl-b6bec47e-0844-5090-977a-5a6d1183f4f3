export SuffixArray

struct SuffixArray
    data::Vector
    index::Vector{Int}
end

function SuffixArray(str::String)
    data = map(Int32, collect(str))
    k = maximum(data)
    index = sais(data, Int(k)+1)
    SuffixArray(data, index)
end

Base.length(sa::SuffixArray) = length(sa.index)

function prefixsearch(sa::SuffixArray, query::Vector{Int32})
    ii = 1
    ij = length(sa)
    while true
        ik = (ii+ij) ÷ 2
        xi = sa.index[ik]

        qi = 1
        while sa.data[xi+qi-1] == query[qi]
            if qi > length(query)
                i = ik
                while getlcp() == lcp
                    i--
                end
                i = ik
                while true
                    i++
                end
                
                for i = ik:-1:1
                    getlcp(sa, i)
                end
            end
            qi == length(query) && break
            xi+qi-1 == length(sa) && break
            qi += 1
        end
        lcp = qi - 1
        ii == ij && return xi:xi+lcp-1

        if sa.data[xi+qi-1] < query[qi]
            ii = ik + 1
        else
            ij = ik - 1
        end
    end
end

function getlcp(sa::SuffixArray, xi::Int, query::Vector)
    qi = 1
    while sa.data[xi+qi-1] == query[qi]
        qi == length(query) && return qi
        xi+qi-1 == length(sa) && return qi
        qi += 1
    end
    qi - 1
end

"""
    lcparray

Kasai's algorithm for linear-time construction of LCP array from Suffix Array
"""
function lcparray(sa::Vector{Int}, data::Vector{T}) where T<:Integer
    n = length(sa)
    lcps = similar(sa)
    rank = similar(sa)
    for i = 1:n
        rank[sa[i]] = i
    end

    lcp = 0
    for i = 1:n
        rank[i] > 1 || continue
        j = sa[rank[i]-1]
        while i+lcp <= n && j+lcp <= n && data[i+lcp] == data[j+lcp]
            lcp += 1
        end
        lcps[rank[i]] = lcp
        lcp > 0 && (lcp -= 1)
    end
    lcps[1] = 0
    lcps
end
