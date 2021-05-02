### A Pluto.jl notebook ###
# v0.14.3

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ e8e2c9d5-15a6-4a3a-81b7-a10c32290f79
# environment setup
begin
	using DrWatson
	quickactivate(findproject())
	
	using Pkg
	Pkg.instantiate()
	
	using Colors, ColorVectorSpace, ImageShow, FileIO
	using ImageShow.ImageCore
	using ColorSchemes
	using InteractiveUtils, PlutoUI
	using Plots
	using Distributions
	using LinearAlgebra
end

# ╔═╡ 03386e5e-937b-4e32-b034-e1689834e0dc
TableOfContents()

# ╔═╡ fe69d7ee-aa66-11eb-0e4e-e16fc28be586
md"# Fractal Drawing"

# ╔═╡ 1f0068b8-4df2-44dd-a3a3-072d3c43d66a
md"## Probabilistic method"

# ╔═╡ 201374df-2c63-4c8f-bfb5-ffcfb1e5be41
# function gen_itr_pts(ifs::IFS,
# 					maxNumPts::Int64=1000, 
# 					initialPt::Vector{Float64}=[0., 0.]) ::Vector{Vector{Float64}}
	
# 	linearIFS = ifs.linear
# 	transIFS = ifs.trans
# 	numMaps = size(transIFS, 1) 
# 	probDistr = Categorical(ones(numMaps)./numMaps)
# 	ptsSet = fill(zeros(Float64, 2), maxNumPts)
# 	ptsSet[1] = initialPt
	
# 	for i = 2:maxNumPts
# 		temptIndex = rand(probDistr)
# 		ptsSet[i] = linearIFS[temptIndex] * ptsSet[i-1] + transIFS[temptIndex]		
# 	end

# 	return ptsSet
# end

# function gen_itr_pts(wifs::WIFS, maxNumPts::Int64=1000)
	
# 	linearIFS = wifs.linear
# 	transIFS = wifs.trans
# 	probDistr = Categorical(wifs.weights)
# 	ptsSet = fill(zeros(Float64, 2), maxNumPts)
# 	ptsSet[1] = ([1 0; 0 1] - linearIFS[1]) \ transIFS[1]
	
# 	for i = 2:maxNumPts
# 		temptIndex = rand(probDistr)
# 		ptsSet[i] = linearIFS[temptIndex] * ptsSet[i-1] + transIFS[temptIndex]		
# 	end

# 	return ptsSet
# end

# ╔═╡ 177eb41d-4c00-492d-8657-c8c9d65b9bd8
@bind selectIFS MultiSelect([ "SierpinskiTriangle" => "Sierpinski Gasket", 
							"BedMcCarpet" => "Bedford-MacMullen Carpet", 
							"BaranskiCarpet" => "Baranski Carpet",
							"HeighwayDragon" => "Heighway Dragon",
							"Twindragon" => "Twindradon",
							"Terdragon" => "Terdragon",
 							"BarnsleyFern" => "Barnsley Fern",
							"myIFSNonlinear" => "nonlinear"];
							default=["SierpinskiTriangle"])

# ╔═╡ 24f874d6-93f6-4f53-941c-4cc3cf56963b
md"""
maxNumPts = $(@bind maxNumPts Slider(1000:1000:200000; default=100000, show_value=true)) $ \quad $ Example Name: $selectIFS
"""

# ╔═╡ 7afa357b-4483-4cff-8b12-9401d42ea53b
function plot_ptsSet(ptsSet::Vector{Vector{Float64}})
	xPtsSet = [x[1] for x in ptsSet]
	yPtsSet = [x[2] for x in ptsSet]
	scatter(xPtsSet, yPtsSet, 
			leg=false,
			markershape=:circle,
			markeralpha=0.7;
			markersize=1,
			# markercolor = :purple,
			# markerstroke=false,
    		markerstrokewidth = 0,
    		# markerstrokealpha = 0.2,
			# grid=false,
			showaxis=false,
			ticks=false,
			xlims=extrema(xPtsSet),
			ylims=extrema(yPtsSet),
			size=(680, 500))
end

# ╔═╡ e63a2bee-5b49-4b73-8598-fcf8c17b478a
pos = [1 0 1 1; 1 1 0 1; 0 1 1 1]

# ╔═╡ 0ba7d829-0a5d-4891-9b50-3203891faa22
hh = [0.1, 0.6, 0.1 , 0.3]

# ╔═╡ 2ca1aa8e-4450-43a2-a15a-ba5d5e2a652f
vv = [0.3, 0.4, 0.3] 

# ╔═╡ aad51fe8-0ba2-4a68-9860-3d6f55dce7d6
md"## Deterministic method"

# ╔═╡ 99984492-63dd-423f-9db7-1c65370bfcfb
md"
!!! note
	See the corresponding matlab program.
"

# ╔═╡ 68185989-796e-4182-a779-3581b3ce42d1
md"## Lindenmayer System"

# ╔═╡ e0606efb-fdab-4812-8e8f-b64142dc3a56
md"
!!! tip
	See the `Lindenmayer.jl`.
"

# ╔═╡ a4bff980-d16d-4127-b519-788398d156dd
md"## Predefined IFS"

# ╔═╡ 30e512ee-b79a-432f-9c49-6413f53f3986
md"### Structs `IFS` `WIFS` `IFSNonlinear` "

# ╔═╡ c126d761-2853-48d4-adad-ca36f338e894
struct IFS
	linear::Vector{Matrix{Float64}}
	trans::Vector{Vector{Float64}}
end

# ╔═╡ fe96caae-2efa-4e4b-968e-921b7c395e81
mutable struct WIFS
	linear::Vector{Matrix{Float64}}
	trans::Vector{Vector{Float64}}
	weights::Vector
	
	WIFS(linear::Vector{Matrix{Float64}}, trans::Vector{Vector{Float64}}, weights::Vector) = isprobvec(weights) ? new(linear, trans, weights) : error("Not prob. vec!")
	
	WIFS(ifs::IFS) = new(ifs.linear, ifs.trans, ones(size(ifs.trans, 1))./size(ifs.trans,1))
	
	WIFS(ifs::IFS, weights::Vector) = isprobvec(weights) ? new(ifs.linear, ifs.trans, weights) : error("Not prob. vec!")

end	

# ╔═╡ 6fb35e53-4f05-409f-90d5-318f7820330c
# write as a function
begin

function gen_itr_pts(linearIFS::Vector{Matrix{Float64}}, 		transIFS::Vector{Vector{Float64}}, weights::Vector{Float64}, maxNumPts::Int64)::Vector{Vector{Float64}}
	
	probDistr = Categorical(weights)
	ptsSet = fill(zeros(Float64, 2), maxNumPts)
	ptsSet[1] = ([1 0; 0 1] - linearIFS[1]) \ transIFS[1]
	
	for i = 2:maxNumPts
		temptIndex = rand(probDistr)
		ptsSet[i] = linearIFS[temptIndex] * ptsSet[i-1] + transIFS[temptIndex]		
	end

	return ptsSet
end	

gen_itr_pts(wifs::WIFS, maxNumPts::Int64) = gen_itr_pts(wifs.linear, wifs.trans, wifs.weights, maxNumPts)
gen_itr_pts(ifs::IFS, maxNumPts::Int64) = gen_itr_pts(WIFS(ifs), maxNumPts)

end

# ╔═╡ b08269be-cc1c-456d-a5d0-fbbd696f15aa
struct IFSNonlinear 
	maps::Vector{Function}
	weights::Vector
	
	IFSNonlinear(maps::Vector{Function}, weights::Vector) = new(maps, weights)
	IFSNonlinear(maps::Vector{Function}) = new(maps, ones(size(maps, 1))./size(maps, 1))
	
end

# ╔═╡ d3e449f3-6318-4d9d-87ee-12d0733b65c9
begin
	f(x) = [0.5*x[1]^2 + x[2], x[2] ^ 3]
	g(x) = [0.2* x[1] * x[2] + 1, -0.3 * x[1] ]
	myIFSNonlinear = IFSNonlinear([f, g])
end

# ╔═╡ 4f36e92b-c2ab-4f65-ab18-65e60cbc2fe1
function gen_itr_pts(ifs::IFSNonlinear, maxNumPts::Int64=1000, initialPt::Vector{Float64}=[0., 0.])
	
	maps = ifs.maps
	probDistr = Categorical(ifs.weights)
	ptsSet = fill(zeros(Float64, 2), maxNumPts)
	ptsSet[1] = initialPt
	
	for i = 2:maxNumPts
		ptsSet[i] = maps[rand(probDistr)](ptsSet[i-1])		
	end

	return ptsSet
	
end

# ╔═╡ 813219ac-0a33-4bf1-8cd3-cf06193bb5d1
# setup
begin
	# test examples
	linearIFS = [[0  0; 0 0.16],
		[ 0.85  0.04; -0.04 0.85 ],
		[ 0.2  -0.26; 0.23 0.22 ],
		[-0.15  0.28; 0.26 0.24 ]]
	transIFS = [[0, 0],
				[0, 1.6], [0, 1.6],
				[0, 0.44]]
	weights = [0.01, 0.84, 0.08, 0.07]
	
	BarnsleyFern = WIFS(linearIFS, transIFS, weights)
	
	plot_ptsSet(gen_itr_pts(BarnsleyFern, maxNumPts))
	
end

# ╔═╡ dc9d671f-5279-4c8f-a4ef-9ee31ce49e76
begin
	if selectIFS[1] == "myIFSNonlinear"
		ptsSet = gen_itr_pts(myIFSNonlinear, maxNumPts)
	else
		itrIFS = eval(Meta.parse("PredefinedIFS." * selectIFS[1]))
		if selectIFS[1] in ["SierpinskiTriangle", "BarnsleyFern", "HeighwayDragon", "Twindragon", "Terdragon"]
			ptsSet = gen_itr_pts(itrIFS, maxNumPts)
		elseif selectIFS[1] == "BedMcCarpet"
			ptsSet = gen_itr_pts(itrIFS(pos), maxNumPts)
		else
			ptsSet = gen_itr_pts(itrIFS(vv, hh, pos), maxNumPts)
		end
	end
		
	println("")
end

# ╔═╡ 5a59bd1c-71e2-44dd-a143-2b3594ddc738
plot_ptsSet(ptsSet)

# ╔═╡ 7a8cbde8-3797-4752-95ec-b0c48bf2824b
begin
	length(wifs::WIFS) = size(wifs.weights, 1)
	length(ifs::IFS) = size(ifs.trans, 1) 
end

# ╔═╡ 13442c56-72b4-4feb-8746-066aa20646c5
md"### Module `PredefinedIFS`"

# ╔═╡ 5fafe065-db05-4153-b519-80ea0d046fae
module PredefinedIFS
	
import ..IFS
import ..WIFS
	
SierpinskiTriangle = IFS([[1/2 0; 0 1/2], 
				  [1/2 0; 0 1/2], 
				  [1/2 0; 0 1/2]],
				 [[0, 0], 
				  [1/2, 0],
				  [1/4, 1/4 * sqrt(3)]])

BarnsleyFern = WIFS([[0  0; 0 0.16],
					 [ 0.85  0.04; -0.04 0.85],
					 [ 0.2  -0.26; 0.23 0.22],
					 [-0.15  0.28; 0.26 0.24]],
					[[0, 0],
					 [0, 1.6], 
					 [0, 1.6],
				 	 [0, 0.44]], 
					[0.01, 0.84, 0.08, 0.07])

HeighwayDragon = IFS([[1/2 -1/2; 1/2 1/2],
					[-1/2 -1/2; 1/2 -1/2]],
					[[0, 0], [1,0]])
Twindragon = IFS([[1/2 -1/2; 1/2 1/2],
					[-1/2 1/2; -1/2 -1/2]],
					[[0, 0], [1,0]])
Terdragon = IFS([[1/2 1/(2*sqrt(3)); -1/(2*sqrt(3)) 1/2],
					[0 -1/sqrt(3); 1/sqrt(3) 0],
					[1/2 1/(2*sqrt(3)); -1/(2*sqrt(3)) 1/2]],
					[[0, 0], [1/2, -1/(2*sqrt(3))], [1/2, 1/(2*sqrt(3))]])

function BaranskiCarpet(v::Vector, h::Vector, pos::Matrix)::IFS
	pos = reverse(pos; dims=1)
	linear = [ [h[x[2]] 0; 0 v[x[1]]] for x in findall(pos .> 0)]
	trans = [ [sum(h[1:x[2]-1]),  sum(v[1:x[1]-1])] for x in findall(pos .> 0)]
	
	return IFS(linear, trans)
end

BedMcCarpet(pos::Matrix) = BaranskiCarpet(ones(size(pos, 1))./size(pos, 1), ones(size(pos, 2))./size(pos, 2), pos)


# function BedMcCarpet(v::Int, h::Int, pos::Matrix)::IFS
# 	pos = reverse(pos; dims=1)
# 	numMaps = sum(pos)
# 	linear = fill([1.0/h 0.; 0 1.0/v], numMaps)
# 	trans = [ [(x[2]-1.0)/h, (x[1]-1)/v] for x in findall(pos .> 0)]
	
# 	return IFS(linear, trans)
# end
   
end # end of module PredefinedIFS

# ╔═╡ 3ba4d982-b95b-40e0-9844-b4801b7a1e89
md"## Appendix"

# ╔═╡ ac80253a-3422-4457-a51b-6baa5b48ce4f
begin
	show_image(M) = get.([ColorSchemes.rainbow], M ./ maximum(M))
	show_image(x::AbstractVector) = show_image(x')
end

# ╔═╡ fbfb70b3-95a8-45cd-9111-648de10e683c
show_image(pos), show_image( vv[i] * hh[j] * pos[i, j] for i in 1:lastindex(vv), j in 1:lastindex(hh))

# ╔═╡ Cell order:
# ╟─e8e2c9d5-15a6-4a3a-81b7-a10c32290f79
# ╟─03386e5e-937b-4e32-b034-e1689834e0dc
# ╟─fe69d7ee-aa66-11eb-0e4e-e16fc28be586
# ╟─1f0068b8-4df2-44dd-a3a3-072d3c43d66a
# ╟─201374df-2c63-4c8f-bfb5-ffcfb1e5be41
# ╟─813219ac-0a33-4bf1-8cd3-cf06193bb5d1
# ╟─d3e449f3-6318-4d9d-87ee-12d0733b65c9
# ╟─dc9d671f-5279-4c8f-a4ef-9ee31ce49e76
# ╟─177eb41d-4c00-492d-8657-c8c9d65b9bd8
# ╟─24f874d6-93f6-4f53-941c-4cc3cf56963b
# ╟─5a59bd1c-71e2-44dd-a143-2b3594ddc738
# ╟─7afa357b-4483-4cff-8b12-9401d42ea53b
# ╠═fbfb70b3-95a8-45cd-9111-648de10e683c
# ╠═e63a2bee-5b49-4b73-8598-fcf8c17b478a
# ╠═0ba7d829-0a5d-4891-9b50-3203891faa22
# ╠═2ca1aa8e-4450-43a2-a15a-ba5d5e2a652f
# ╟─aad51fe8-0ba2-4a68-9860-3d6f55dce7d6
# ╟─99984492-63dd-423f-9db7-1c65370bfcfb
# ╟─68185989-796e-4182-a779-3581b3ce42d1
# ╟─e0606efb-fdab-4812-8e8f-b64142dc3a56
# ╟─a4bff980-d16d-4127-b519-788398d156dd
# ╟─6fb35e53-4f05-409f-90d5-318f7820330c
# ╟─4f36e92b-c2ab-4f65-ab18-65e60cbc2fe1
# ╟─30e512ee-b79a-432f-9c49-6413f53f3986
# ╠═c126d761-2853-48d4-adad-ca36f338e894
# ╠═fe96caae-2efa-4e4b-968e-921b7c395e81
# ╠═b08269be-cc1c-456d-a5d0-fbbd696f15aa
# ╠═7a8cbde8-3797-4752-95ec-b0c48bf2824b
# ╟─13442c56-72b4-4feb-8746-066aa20646c5
# ╠═5fafe065-db05-4153-b519-80ea0d046fae
# ╟─3ba4d982-b95b-40e0-9844-b4801b7a1e89
# ╟─ac80253a-3422-4457-a51b-6baa5b48ce4f
