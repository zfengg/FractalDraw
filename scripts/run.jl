# plot
function plotPts(ptsSet::Vector{Vector{Float64}}, mc::String="#009AFA")
	xs = [x[1] for x in ptsSet]
	ys = [x[2] for x in ptsSet]
	scatter(xs, ys, 
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
			xlims=extrema(xs),
			ylims=extrema(ys),
			# size=(680, 500)
            )
end

# setup
linearIFS = [[0 0; 0 0.16],
    [0.85 0.04; -0.04 0.85],
    [0.2 -0.26; 0.23 0.22],
    [-0.15 0.28; 0.26 0.24]]
transIFS = [[0, 0],
    [0, 1.6],
    [0, 1.6],
    [0, 0.44]]
weights = [0.01, 0.84, 0.08, 0.07]
## plot settings
numPts = 3000000
color = "#009AFA"
shoudSave = true
filename = "vscodetest.pdf"

# create the weighted IFS
myWIFS = WIFS(linearIFS, transIFS, weights)


myplt = plotPts(itrPtsProb(myWIFS, numPts, [-100, -100]), color)
shoudSave && savefig(myplt, joinpath("plots", filename))
