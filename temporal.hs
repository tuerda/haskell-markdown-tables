-- Leer y escribir a markdown
-- module Markdown (fromMarkdown, toMarkdown) where

import Data.List (transpose)

-- No todos los [String] son lineas. Esto ayudará a indicar cuándo sí
type Line = [String]
type Table = [Line]

-- Dividimos cada renglón en columnas
splitAtBar :: String -> Line
splitAtBar []=[]
splitAtBar (x:xs)
    | x== '|' = []:splitAtBar xs
    | xs == [] = [[x]]
    | otherwise = (x:head (splitAtBar xs)): tail (splitAtBar xs)

-- De una lista de strings a una tabla pura
fromMarkdown :: [String] -> Table
fromMarkdown mark = map (filter (/="") . splitAtBar) xs where
    xs = filter (not . all(`elem`['-','|',' '])) mark

------------------------------------

-- De una tabla pura a una tabla en markdown formateada
toMarkdown :: Table -> [String]
toMarkdown tabla1 =
    let
        matrizLongs = [[length w | w <- line] | line <- tabla1] -- Matriz de las longitudes
        longitudesMax = maxTranspose matrizLongs -- Vector de longitudes máximas
        chonchesote = map (zipWith (addSpaces) longitudesMax) tabla1 -- todo sin subrayar ni dividir.
        subrayado = (underline $ head chonchesote) ++ tail chonchesote -- agrega la rayita
        sinPrimeraBarra = [[x++"|"|x<-xs]| xs<-subrayado]--Con las barras verticales después de cada entrada
        final=map (["|"] ++) sinPrimeraBarra
    in
        [foldl1 (++) x | x <- final] -- Juntamos de nuevo

-------------------------------------

-- Máximo de la transpuesta
maxTranspose :: (Ord a) => [[a]]->[a]
maxTranspose a=map (maximum) (transpose a)

-- Agregar espacios al final de cada celda para emparejar el largo.
addSpaces :: Int->String->String
addSpaces x b = b++take (x - length b) (repeat ' ')

-- Subrayar una celda
underlineOne :: String->[[String]]
underlineOne x = transpose [[x, replicate (length x) '-']]

--- Subrayar una linea (vector) sale una matriz
underline :: [String]->[[String]]
underline (x:[]) = underlineOne x
underline (x:xs) = zipWith (++) (underlineOne x) (underline xs)
