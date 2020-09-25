-- Leer y escribir LaTeX

-- Hacemos la suposición de que ninugna linea de la tabla empieza con \
-- y que todo lo que no empieza con \ es la tabla misma
-- No convertimos formato de LaTeX, solo las partes que indican los bordes de la tabla

-- La salida viene en una tabla con todas las lineas verticales y horizontales

module LaTeX (fromLaTeX, toLaTeX) where

type Line = [String]
type Table = [Line]

--Quita el espacio en blanco al principio
removeStartingWhitespace :: String -> String
removeStartingWhitespace str = dropWhile (isWhiteSpace) str
    where isWhiteSpace x = ( x == ' ' ) || ( x == '\t' )

--Decide si el primer caracter no vacío es \
startsWithBackslash :: String -> Bool
startsWithBackslash str = head (removeStartingWhitespace str) == '\\'

--Decide si el primer caracter no vacío es %
isComment :: String -> Bool
isComment str = head (removeStartingWhitespace str) == '%'

-- Dividimos cada renglón en columnas
splitAtAmpersand :: String -> Line
splitAtAmpersand []=[]
splitAtAmpersand (x:xs)
    | x== '&' = []:splitAtAmpersand xs
    | xs == [] = [[x]]
    | otherwise = (x:head (splitAtAmpersand xs)): tail (splitAtAmpersand xs)

--Convierte de LaTeX a una tabla abstracta.
fromLaTeX :: [String] -> Table
fromLaTeX texTable=
    let
        realStuff = filter (\x -> not (isComment x) || startsWithBackslash x) texTable
    in
        map (filter (/="") . splitAtAmpersand) realStuff

toLaTeX :: String -> Table -> [String]
toLaTeX archivo tabla = 
    let numeroDeColumnas = length . head $ tabla
        marcadecolumnas = "|" ++ ( unwords $ replicate numeroDeColumnas "c|" ) --antes de la tabla 
        lineasArchivo = lines archivo
        antes = takeWhile (/= "AQUIVALATABLA") lineasArchivo
        despues = reverse $ takeWhile (/= "AQUIVALATABLA") $ reverse lineasArchivo
        (arreglame, resto) = (head (reverse antes), reverse (tail $ reverse antes))
        arreglado = (reverse $ drop 1 $ reverse arreglame) ++ marcadecolumnas ++ "}"
        inicio = antes ++ [arreglado]
        lineastabla = map (( ++"\\\\" ) . drop 3 . unwords . map ( " & " ++)) tabla
        tablaLista = foldl (\x y -> x ++ [y] ++ ["\\hline"] ) [] lineastabla
    in
        inicio ++ tablaLista ++ despues
