-- Programa en Haskell para traducir formatos de tablas

import System.Environment (getArgs)
import System.Directory (getHomeDirectory)
import System.IO
import qualified LaTeX as L
import qualified Markdown as M
import qualified CSV as C

main = do
    argumentos <- getArgs
    home <- getHomeDirectory
    archivo <- readFile $ home ++ "/.config/tabla/esqueleto.tex" -- lazy IO, si no es relevante no lo lee
    if argumentos == [] -- Markdown es default.
        then interact $ unlines . M.toMarkdown . M.fromMarkdown . lines
        else do
            pretabla <- getContents
            let primero = head argumentos
                segundo = head $ tail argumentos
                tabla = tablify primero pretabla
                tablasalida = unlines $ untablify segundo tabla archivo
            putStr tablasalida

tablify prim pret
    | prim `elem` ["tex" , "latex" , "Tex", "LaTeX", "Latex"] = L.fromLaTeX . lines $ pret
    | prim `elem` ["md" , "markdown" , "Markdown"] = M.fromMarkdown . lines $ pret
    | prim `elem` ["csv" , "CSV"] = C.fromCSV . lines $ pret

untablify seg tab arch
    | seg `elem` ["tex" , "latex" , "Tex" ] = L.toLaTeX arch tab
    | seg `elem` ["md" , "markdown" , "Markdown" ] = M.toMarkdown tab
    | seg `elem` ["csv" , "CSV" ] = C.toCSV tab
