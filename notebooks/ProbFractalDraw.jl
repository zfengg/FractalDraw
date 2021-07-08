### A Pluto.jl notebook ###
# v0.14.8

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

# ╔═╡ c797f938-ab2a-4c0b-99a1-dc1d8a975193
include(srcdir("IFS.jl"));

# ╔═╡ 03386e5e-937b-4e32-b034-e1689834e0dc
TableOfContents()

# ╔═╡ fe69d7ee-aa66-11eb-0e4e-e16fc28be586
md"# Fractal Drawing"

# ╔═╡ 1f0068b8-4df2-44dd-a3a3-072d3c43d66a
md"## Probabilistic method"

# ╔═╡ df738342-cb99-4a8e-9565-2b9422caaee2
md"### Basic usage"

# ╔═╡ cffe70b9-17bc-467a-b2c1-7a01e46ce494
begin
	# set the parameters
	linearIFS = [[0  0; 0 0.16],
				 [0.85  0.04; -0.04 0.85 ],
				 [0.2  -0.26; 0.23 0.22],
				 [-0.15  0.28; 0.26 0.24]]
	transIFS = [[0, 0],
				[0, 1.6], 
				[0, 1.6],
				[0, 0.44]]
	weights = [0.01, 0.84, 0.08, 0.07]
	# create the weighted IFS
	myWIFS = WIFS(linearIFS, transIFS, weights)
end

# ╔═╡ 87b32b70-a405-42db-87bd-16a44644e334
md"### Gallery"

# ╔═╡ 24f874d6-93f6-4f53-941c-4cc3cf56963b
md"""
numPts: $(@bind maxNumPts Slider(1000:1000:300000; default=100000, show_value=true)) $ \quad $ Example: $(@bind selectIFS MultiSelect([ "SierpinskiTriangle" => "Sierpinski Triangle", 
							"BedMcCarpet" => "Bedford-MacMullen Carpet", 
							"BaranskiCarpet" => "Baranski Carpet",
							"HeighwayDragon" => "Heighway Dragon",
							"Twindragon" => "Twindradon",
							"Terdragon" => "Terdragon",
 							"BarnsleyFern" => "Barnsley Fern",
							"myIFSNonlinear" => "nonlinear"];
							default=["SierpinskiTriangle"])) $ \quad $ Color: $(@bind myColor ColorStringPicker(default="#009AFA"))
"""

# ╔═╡ 5f8abed9-0be7-43c7-a6a5-8f93a94eb5ce
md"Bed-MacMullen carpet setup:"

# ╔═╡ e63a2bee-5b49-4b73-8598-fcf8c17b478a
posBM = [1 0 1 1; 
		1 0 1 0; 
		0 1 1 0;]

# ╔═╡ 106cbdcb-8041-40e4-924a-4693c8d2ea10
md"Baranski carpet setup:"

# ╔═╡ e46ee341-23bb-45a0-8e00-58afdd825634
 vv = [0.6, 0.1, 0.3]

# ╔═╡ 0ba7d829-0a5d-4891-9b50-3203891faa22
hh = [0.5, 0.1, 0.1 , 0.3]

# ╔═╡ 2ca1aa8e-4450-43a2-a15a-ba5d5e2a652f
posB = [1 1 0 1; 
	   1 0 0 1; 
	   0 1 1 1]

# ╔═╡ d3e449f3-6318-4d9d-87ee-12d0733b65c9
begin
	f(x) = [0.5*x[1]^2 + x[2], x[2] ^ 3]
	g(x) = [0.2* x[1] * x[2] + 1, -0.3 * x[1] ]
	myIFSNonlinear = IFSNonlinear([f, g], 2)
end;

# ╔═╡ dc9d671f-5279-4c8f-a4ef-9ee31ce49e76
begin
	if selectIFS[1] == "myIFSNonlinear"
		ptsSet = itrPtsProb(myIFSNonlinear, maxNumPts)
	else
		itrIFS = eval(Meta.parse("PredefinedIFS." * selectIFS[1]))
		if selectIFS[1] in ["SierpinskiTriangle", "BarnsleyFern", "HeighwayDragon", "Twindragon", "Terdragon"]
			ptsSet = itrPtsProb(itrIFS, maxNumPts)
		elseif selectIFS[1] == "BedMcCarpet"
			ptsSet = itrPtsProb(itrIFS(posBM), maxNumPts)
		else
			ptsSet = itrPtsProb(itrIFS(vv, hh, posB), maxNumPts)
		end
	end
		
	println("")
end

# ╔═╡ aad51fe8-0ba2-4a68-9860-3d6f55dce7d6
md"## Deterministic method"

# ╔═╡ 99984492-63dd-423f-9db7-1c65370bfcfb
md"""
!!! note
	The method has been implemented via matlab script [`PlanarAffineIFS.m`](https://github.com/zfengg/FractalDraw/blob/master/scripts/matlab/2DIFSPlot/PlanarAffineIFS.m).
"""

# ╔═╡ 68185989-796e-4182-a779-3581b3ce42d1
md"## Lindenmayer System"

# ╔═╡ e0606efb-fdab-4812-8e8f-b64142dc3a56
md"""
!!! note
	The first implementation is based upon [`Lindenmayer.jl`](https://github.com/cormullion/Lindenmayer.jl).
"""

# ╔═╡ 3a84c3cd-e519-4398-89f8-a49c608fdb98
md"### Basic usage"

# ╔═╡ b63e0adb-7125-4fdd-a654-87963bf13282


# ╔═╡ f96a33a5-e70f-4807-8974-d4362ef424db
md"### Gallery"

# ╔═╡ 3ba4d982-b95b-40e0-9844-b4801b7a1e89
md"## Appendix"

# ╔═╡ 7afa357b-4483-4cff-8b12-9401d42ea53b
begin
function plot_ptsSet(ptsSet::Vector{Vector{Float64}}, mc::String="#009AFA")
	xPtsSet = [x[1] for x in ptsSet]
	yPtsSet = [x[2] for x in ptsSet]
	scatter(xPtsSet, yPtsSet, 
			leg=false,
			markershape=:circle,
			markeralpha=0.7;
			markersize=1,
			markercolor=mc,
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
# function plot_ptsSet(ptsSet::Vector{Vector{Float64}}, makercolor::String)
# 	xPtsSet = [x[1] for x in ptsSet]
# 	yPtsSet = [x[2] for x in ptsSet]
# 	scatter(xPtsSet, yPtsSet, 
# 			leg=false,
# 			markershape=:circle,
# 			markeralpha=0.7;
# 			markersize=1,
# 			# markercolor = :purple,
# 			# markerstroke=false,
#     		markerstrokewidth = 0,
#     		# markerstrokealpha = 0.2,
# 			# grid=false,
# 			showaxis=false,
# 			ticks=false,
# 			xlims=extrema(xPtsSet),
# 			ylims=extrema(yPtsSet),
# 			size=(680, 500))
# end
	
end

# ╔═╡ 5c10f0b0-2275-459d-a6a2-357c8dfb1af1
# generate and plot the points
plot_ptsSet(itrPtsProb(myWIFS, 300000))	

# ╔═╡ 5a59bd1c-71e2-44dd-a143-2b3594ddc738
plot_ptsSet(ptsSet, myColor)

# ╔═╡ ac80253a-3422-4457-a51b-6baa5b48ce4f
begin
	show_image(M) = get.([ColorSchemes.rainbow], M ./ maximum(M))
	show_image(x::AbstractVector) = show_image(x')
end

# ╔═╡ fbfb70b3-95a8-45cd-9111-648de10e683c
show_image(posBM)

# ╔═╡ 466de16d-7eeb-427b-b81e-eddb9b93efb3
show_image( (vv * reshape(hh, 1, :)) .* posB)

# ╔═╡ 210c8db0-5083-470c-811b-1aca62ee24b2
function ingredients(path::String)
	# this is from the Julia source code (evalfile in base/loading.jl)
	# but with the modification that it returns the module instead of the last object
	name = Symbol(basename(path))
	m = Module(name)
	Core.eval(m,
        Expr(:toplevel,
             :(eval(x) = $(Expr(:core, :eval))($name, x)),
             :(include(x) = $(Expr(:top, :include))($name, x)),
             :(include(mapexpr::Function, x) = $(Expr(:top, :include))(mapexpr, $name, x)),
             :(include($path))))
	m
end

# ╔═╡ d726d487-35bc-4233-b613-93e4c4af2984
# ingredients(srcdir("IFS.jl"))

# ╔═╡ 177eb41d-4c00-492d-8657-c8c9d65b9bd8
# @bind selectIFS MultiSelect([ "SierpinskiTriangle" => "Sierpinski Gasket", 
# 							"BedMcCarpet" => "Bedford-MacMullen Carpet", 
# 							"BaranskiCarpet" => "Baranski Carpet",
# 							"HeighwayDragon" => "Heighway Dragon",
# 							"Twindragon" => "Twindradon",
# 							"Terdragon" => "Terdragon",
#  							"BarnsleyFern" => "Barnsley Fern",
# 							"myIFSNonlinear" => "nonlinear"];
# 							default=["SierpinskiTriangle"])

# ╔═╡ Cell order:
# ╟─e8e2c9d5-15a6-4a3a-81b7-a10c32290f79
# ╟─c797f938-ab2a-4c0b-99a1-dc1d8a975193
# ╟─03386e5e-937b-4e32-b034-e1689834e0dc
# ╟─fe69d7ee-aa66-11eb-0e4e-e16fc28be586
# ╟─1f0068b8-4df2-44dd-a3a3-072d3c43d66a
# ╟─df738342-cb99-4a8e-9565-2b9422caaee2
# ╠═cffe70b9-17bc-467a-b2c1-7a01e46ce494
# ╟─5c10f0b0-2275-459d-a6a2-357c8dfb1af1
# ╟─87b32b70-a405-42db-87bd-16a44644e334
# ╟─24f874d6-93f6-4f53-941c-4cc3cf56963b
# ╟─5a59bd1c-71e2-44dd-a143-2b3594ddc738
# ╟─dc9d671f-5279-4c8f-a4ef-9ee31ce49e76
# ╟─5f8abed9-0be7-43c7-a6a5-8f93a94eb5ce
# ╠═fbfb70b3-95a8-45cd-9111-648de10e683c
# ╠═e63a2bee-5b49-4b73-8598-fcf8c17b478a
# ╟─106cbdcb-8041-40e4-924a-4693c8d2ea10
# ╟─466de16d-7eeb-427b-b81e-eddb9b93efb3
# ╟─e46ee341-23bb-45a0-8e00-58afdd825634
# ╟─0ba7d829-0a5d-4891-9b50-3203891faa22
# ╟─2ca1aa8e-4450-43a2-a15a-ba5d5e2a652f
# ╟─d3e449f3-6318-4d9d-87ee-12d0733b65c9
# ╟─aad51fe8-0ba2-4a68-9860-3d6f55dce7d6
# ╟─99984492-63dd-423f-9db7-1c65370bfcfb
# ╟─68185989-796e-4182-a779-3581b3ce42d1
# ╟─e0606efb-fdab-4812-8e8f-b64142dc3a56
# ╟─3a84c3cd-e519-4398-89f8-a49c608fdb98
# ╠═b63e0adb-7125-4fdd-a654-87963bf13282
# ╟─f96a33a5-e70f-4807-8974-d4362ef424db
# ╟─3ba4d982-b95b-40e0-9844-b4801b7a1e89
# ╟─7afa357b-4483-4cff-8b12-9401d42ea53b
# ╟─ac80253a-3422-4457-a51b-6baa5b48ce4f
# ╟─210c8db0-5083-470c-811b-1aca62ee24b2
# ╟─d726d487-35bc-4233-b613-93e4c4af2984
# ╟─177eb41d-4c00-492d-8657-c8c9d65b9bd8
