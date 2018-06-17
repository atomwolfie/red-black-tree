{-# LANGUAGE BangPatterns #-}
import Data.List (foldl')
import qualified Data.Sequence as S
import Data.RedBlackTree.BinaryTree
import Data.RedBlackTree

instance BinaryTreeNode Int where
  mergeNodes leftInt rightInt = leftInt

getBalancedValues :: [Int] -> [Int]
getBalancedValues [] = [] 
getBalancedValues [a] = [a] 
getBalancedValues [a, b] = [a, b] 
getBalancedValues [a, b, c] = [b, a, c] 
getBalancedValues originalValues = centerValue `seq` remainder `seq` (centerValue:remainder)
  where len = length originalValues
        breakPoint = truncate $ (fromIntegral len) / 2
        lvalues = take breakPoint originalValues
        (centerValue:rvalues) = drop breakPoint originalValues
        remainder = concat [getBalancedValues lvalues, getBalancedValues rvalues]

insertToBalancedTree :: BinaryTree Int -> Int -> BinaryTree Int
insertToBalancedTree !tree !newValue = newTree
  where !newTree = betterInsert tree newValue

leftMostValue :: BinaryTree a -> Maybe a
leftMostValue Leaf = Nothing
leftMostValue (Branch Leaf value _) = Just value
leftMostValue (Branch ltree _  _) = leftMostValue ltree

runBinaryTreeTest :: [Int] -> String
runBinaryTreeTest items =
    let 
        balancedValues = getBalancedValues items
        tree = foldl' insertToBalancedTree Leaf balancedValues
        leftMost = leftMostValue tree
    in
      "constructed tree of with left most value:  " ++ (show leftMost)

runRBTreeTest :: [Int] -> String
runRBTreeTest items =
    let 
        tree = foldl' insert emptyRedBlackTree items
        height = getBlackHeight tree
    in
      "constructed tree of size " ++ (show height)

insertTriples :: S.Seq Int -> Int -> S.Seq Int
insertTriples sequence newInt = sequence S.|> newTriple 
  where newTriple = newInt `seq` newInt * 3

runSequenceTest :: [Int] -> String
runSequenceTest ints =  
  let 
      sequenceOfTriples = foldl' insertTriples S.empty ints
      lastIndex = length ints - 1
      lastTriple = S.index sequenceOfTriples lastIndex 
  in
      "constructed sequence. last triple is " ++ (show lastTriple)

main :: IO ()
main = putStrLn $ runBinaryTreeTest items
  where items = [1..(truncate 1e5)] :: [Int]
