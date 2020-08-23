-- Programa en Haskell para traducir formatos de tablas

import System.Environment (getArgs)
import Markdown
import LaTeX
import CSV

main = do
    argumentos <- fmap words getArgs
    if argumentos == "" -- Markdown es default.
        then interact $ unlines . toMarkdown . fromMarkdown . lines
        else do
            pretabla <- getContents
            let primero = head argumentos
                segundo = head tail argumentos
                tabla = case primero of 
                             "tex" || "latex" || "Tex" -> fromLatex pretabla
                             "md" || "markdown" || "Markdown" -> fromMarkdown pretabla
                             "csv" || "CSV" -> fromCsv pretabla
                tablasalida = unlines case segundo of
                                           "tex" || "latex" || "Tex" -> toLatex tabla
                                           "md" || "markdown" || "Markdown" -> toMarkdown tabla
                                           "csv" || "CSV" -> toCsv tabla
            putStr tablasalida


-- splitatbar :: String->[String]
-- splitatbar []=[]
-- splitatbar (x:xs) 
--     | x== '|' = []:splitatbar xs
--     | xs == [] = [[x]]
--     | otherwise = (x:head (splitatbar xs)): tail (splitatbar xs)

-- -- Esto nos permite calcular el largo de cada columna en un renglón
-- longitudes :: String -> [Int]
-- longitudes x = [length a|a<-splitatbar x]

-- -- Esto nos permite obtener una matriz de anchos
-- longTrans :: [String] -> [[Int]]
-- longTrans xs = [longitudes x | x<-xs]

-- -- Aquí transponemos una matriz para obtener los máximos
-- transpose :: [[a]]->[[a]]
-- transpose [] = []
-- transpose (x:[])=[[a]| a<-x]
-- transpose (x:xs)=zipWith (++) (transpose [x]) (transpose xs)

-- -- Máximo de la transpuesta
-- maxtranspose :: (Ord a) => [[a]]->[a]
-- maxtranspose a=map (maximum) (transpose a)

-- -- Agregar espacios al final de cada celda para emparejar el largo.
-- addspaces :: Int->String->String
-- addspaces x b = b++take (x - length b) (repeat ' ')

-- -- Subrayar una celda
-- underlineone :: String->[[String]]
-- underlineone x = transpose [[x, replicate (length x) '-']]

-- --- Subrayar una linea (vector) sale una matriz
-- underline :: [String]->[[String]]
-- underline (x:[]) = underlineone x
-- underline (x:xs) = zipWith (++) (underlineone x) (underline xs)

-- -- Combina todo para construir la tabla
-- maketable :: [String] -> [String]->[String]
-- maketable args tabla1 =
--     let
--         xs = filter (not . all(`elem`['-','|',' '])) tabla1 -- Quitamos las lineas que sean puros guiones barras y espacios.
--         matrizLongs = longTrans xs -- Matriz de las longitudes
--         longitudesMax = maxtranspose matrizLongs -- Vector de longitudes máximas
--         chonchesote = map (zipWith (addspaces) longitudesMax) [filter (/=[]) (splitatbar x) | x<-xs] -- todo sin subrayar ni dividir. Esto está bien haskeloso.
--         subrayado = if args==["-l"] then foldl1 (++) [underline x | x <- (chonchesote)] else (underline $ head chonchesote) ++ tail chonchesote -- agrega las rayitas
--         sinprimeralinea = [[x++"|"|x<-xs]| xs<-subrayado]--Con las barras verticales después de cada entrada
--         final=map (["|"] ++) sinprimeralinea 
--     in 
--         [foldl1 (++) x | x <- final] -- Juntamos de nuevo
