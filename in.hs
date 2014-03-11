data Maybe a = Just a 
			 | Nothing

data List a = EL | Cons a (List a)

data BTree a = Null | Node a (BTree a) (BTree a)