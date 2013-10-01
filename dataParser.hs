import Language.Haskell.Exts
 
(%) :: String -> [String] -> String
"" % _ = error "not completely consumed"
[x] % _ = error "not completely consumed"
('%':'s':rest) % [x] = x++rest
('%':'s':rest) % (x:xs) = x++rest % xs
(x:xs) % list = x:xs % list 

extractData :: ParseResult Module -> [DataTypeDecl]
extractData (ParseOk (Module _ _ _ _ _ _ x)) = map parseData $ onlyData x
	where
		onlyData :: [Decl] -> [Decl]
		onlyData [] = []
		onlyData (x@(DataDecl _ _ _ _ _ _ _):xs) = x:onlyData xs
		onlyData (_:xs) = onlyData xs
extractData x = error (show x)

data DataTypeDecl = DataTypeDecl String [String] [Constructor]

instance Show DataTypeDecl where
		show (DataTypeDecl name args constructors) = "(DataTypeDecl,\"%s\",%s,%s)"%
													[name,show args,show constructors]

data Constructor = Constructor String [TypeTree]

instance Show Constructor where
		show (Constructor name typetrees) = "(Constructor,%s)"%[show typetrees]

data TypeTree = TypeNode String [TypeTree]
			  | TypeVar String
			  | TypeConst String
			  | TypeList TypeTree

instance Show TypeTree where
		show (TypeNode name children) = "(TypeNode,\"%s\",%s)"%
													[name,show children]
		show (TypeVar var) = "(TypeVar,%s)"%[show var]
		show (TypeConst var) = "(TypeConst,%s)"%[show var]
		show (TypeList child) = "(TypeList,%s)"%[show child]


parseData :: Decl -> DataTypeDecl
parseData (DataDecl _ DataType _ (Ident name) bindings constructors _)
		= DataTypeDecl name (transBindings bindings) (map transConstructor constructors)
	where
		transBindings list = map lol list
			where lol (UnkindedVar (Ident n)) = n

transConstructor :: QualConDecl -> Constructor
transConstructor (QualConDecl _ _ _ (ConDecl (Ident name) types))
	= Constructor name (transTypes types)

transTypes :: [BangType] -> [TypeTree]
transTypes bangTypes = (map (transType . unbang) bangTypes)
		where unbang (UnBangedTy x) = x

transType :: Type -> TypeTree
transType (TyVar (Ident name)) = TypeVar name
transType (TyCon (UnQual (Ident name))) = TypeConst name
transType (TyCon (Special UnitCon)) = TypeNode "Tuple" []
transType (TyParen x) = transType x
transType (TyApp x y) = case unpackTypes (TyApp x y) of
			((TypeConst name):others) -> TypeNode name others
transType (TyList list) = TypeList (transType list)
transType (TyTuple _ (list)) = TypeNode "Tuple" d
		where d = (map transType list)
transType x = error (show x)

unpackTypes :: Type -> [TypeTree]
unpackTypes (TyApp x y) = (unpackTypes x)++[transType y]
unpackTypes x = [transType x]

main = do
	x <- parseFile "in.hs"
	writeFile "out.py" (show $ extractData x)