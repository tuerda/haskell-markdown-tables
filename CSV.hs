-- Leer y escribir a csv
module CSV (fromCSV, toCSV) where

import Data.List (transpose)

-- No todos los [String] son lineas. Esto ayudará a indicar cuándo sí
type Line = [String]
type Table = [Line]

-- Dividimos cada renglón en columnas
splitAtComma :: String -> Line
splitAtComma []=[]
splitAtComma (x:xs)
    | x== ',' = []:splitAtComma xs
    | xs == [] = [[x]]
    | otherwise = (x:head (splitAtComma xs)): tail (splitAtComma xs)

-- De una lista de strings a una tabla pura

fromCSV :: [String] -> Table
fromCSV mark = map (filter (/="") . splitAtComma) xs where -- Quitamos entradas inexistentes (si hay un espacio entre las comas, se queda).
    xs = filter (not . all(`elem`[',',' '])) mark -- Quitamos filas en blanco

------------------------------------

-- De una tabla pura a una tabla en csv
toCSV :: Table -> [String]
toCSV tabla1 =
    let
        vuelta = map reverse tabla1
        (ultimo, resto) = (map head vuelta, map tail vuelta)
        concomas = map (map (\x->x++",")) resto
        enorden = map reverse $ zipWith (:) ultimo concomas
    in
        map (foldl1 (++)) enorden
