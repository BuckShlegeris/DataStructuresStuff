from sympy import *
from subprocess import call


TypeNode = "TypeNode"
TypeVar = "TypeVar"
TypeConst = "TypeConst"
TypeList = "TypeList"
DataTypeDecl = "DataTypeDecl"
Constructor = "Constructor"
Null = "Null"
Node = "Node"
BTree = "BTree"

def translateTypes(instr):
	with open("in.hs",'w') as f:
		f.write(instr)
	call(["./dataParser"])
	with open("out.py") as f:
		return eval(f.read())

def solveEquation(datatype):
	#print S("%s%s"%(datatype[1],tuple(datatype[2])))
	return solve(findEquation(datatype),S("%s%s"%(datatype[1],tuple(datatype[2]))))[0]

def findEquation(datatype):
	assert datatype[0] == DataTypeDecl
	return (reduce((lambda x, y: x+y),
					(constrToMath(term) for term in datatype[3])) 
							- S("%s%s"%(datatype[1],tuple(datatype[2]))))

def constrToMath(constr):
	assert constr[0]=="Constructor"
	return reduce((lambda x, y: x*y),(typeToMath(term) for term in constr[1]),1)

def typeToMath(tree):
#	print tree
	if tree[0]==TypeNode:
		if tree[1]=="Maybe":
			return typeToMath(tree[2][0])+1
		if tree[1]=="Either":
			return typeToMath(tree[2][0])+typeToMath(tree[2][1])
		if tree[1]=="Tuple":
			return reduce((lambda x, y: x*y),(typeToMath(term) for term in tree[2]),1)
		return S("%s%s"%(tree[1],tuple(map(typeToMath,tree[2]))))

	if tree[0]==TypeVar:
		return S(tree[1])
	if tree[0]==TypeConst:
		if tree[1]=="Bool":
			return 2
		if tree[1]=="Unit":
			return 2
		return S(tree[1])
	if tree[0]==TypeList:
		return 1/(1-typeToMath(tree[1]))
	raise Exception(tree)

def val(function,var,n):
	derivativeFunction = function
	for a in range(n):
		derivativeFunction = diff(derivativeFunction,var)
		#print derivativeFunction
	return (derivativeFunction, derivativeFunction.subs(var,0)/factorial(n))[1]

def nDerivatives(func,var,n):
	outlist = []
	for a in range(n):
		outlist.append(val(func,var,a))
	return outlist




dataStructures = open("dataExamples.hs").read()


for structure in translateTypes(dataStructures):
	print "Analysing %s:"%structure[1]

	try:
		print "Equation solution:"
		print solveEquation(structure)
	except IndexError:
		print "That didn't work--probably your data structure is infinite."
	else:
		print "Power series expansion:"
		try:
			print series(solveEquation(structure),n=12)
		except KeyError:
			print "nope, key error"

	#(1+x)**3 * (1+x+x**2)**2raw_input()

	print