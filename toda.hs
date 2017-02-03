import Data.List

----------------------------------------------
------- Changeable parameters ----------------

n = 100  -- number of points (spacing between points is implictly 1)
h = 0.2  -- timestep
t = 50  -- final time
ts = floor (t/h) -- number of timesteps

----------------------------------------------
------- Various initial condtions ------------

xinit :: [Double]
xinit = map (\x -> x + soliton 2 x) [1..n] 
	where soliton k x = 5*(log ( (1+(exp (k*(x-20)))) / (1+(exp (k*(x-19))))))
-- block xinit = [1..(n/4)] ++ ( map (1.0+) [((n/4)+1)..(n/2)] ) ++ [((n/2)+1)..n]
-- sin xinit = zipWith (+) [1..n] sinx where sinx = map (\x -> 0.5*(sin (x/5.0))) [1..n]
-- equilibrium xinit = [1..n]
vinit :: [Double]
vinit = map (vsoliton 2) [1..n] 
	where vsoliton k x = 0*k*( ((exp k)-1)*(exp (k*(x+19))) / ( ((exp (k*x))+(exp(k*19)))*((exp (k*x))+(exp (k*20))) ) )
-- delta vinit = (replicate 20 0.0) ++ [-0.2] ++ (replicate 79 0.0)
-- equlibrium vinit = (replicate 100 0.0)

---------------------------------------------
------- Force calculations and output -------

-- The complicated arguments in l and r are the xs rotated L and R by one element
-- (this implicitly uses periodic bundary conditions)
todaForce x = zipWith (-) (map exp l) (map exp r) 
	where
		l = zipWith (-) (((last x)-n):(init x))  x 
		r = zipWith (-) x ((tail x)++[((head x)+n)])

-- Explicitly typed to ensure correct type propagation elsewhere
verletStep :: ( [Double] -> [Double] ) -> [[Double]] -> [[Double]]
verletStep f xs@(xnow:xprev:_) = 
	( zipWith3 (\x y z -> 2*x - y + h*h*z) xnow xprev (f xnow) ):xs

-- iterate f x = [f x, f f x, f f f x, ...] (an infinite list) and !! n grabs 
-- the nth element. Hooray for lazy evaluation!
solution = iterate (verletStep todaForce)
	[(zipWith3 (\x y z -> x+y+0.5*h*h*z) xinit vinit (todaForce xinit)) , xinit] !! ts

-- What is actually printed are the deviations from equilibrium position
-- (solutionDeltas = [q_i - i]). 
main = mapM_ printRow $ transpose $ ([1..n]:(reverse solutionDeltas))
	where 
		solutionDeltas = map (\x -> zipWith (-) x [1..n]) solution
		print_ x = putStr $ (show x) ++ "\t"
		printRow xs = (mapM_ print_) xs >> putStrLn ""
		--printRow = putStrLn $ unwords $ map show