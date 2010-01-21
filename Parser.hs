module Parser (eval, formula) where
import Nock
import Text.ParserCombinators.Parsec
import Text.ParserCombinators.Parsec.Language (haskellStyle)
import qualified Text.ParserCombinators.Parsec.Token as T

eval :: String -> Formula
eval x = case parse formula "" x of
              Right f  -> reduce f
              Left err -> error "Invalid formula."

formula :: Parser Formula
formula = atom <|> cell <|> expr <|> var

atom = integer >>= return . Atom

var = identifier >>= return . Var

cell = brackets (many1 formula) >>= return . foldr1 (:-)

expr = do
    m <- modifier
    f <- formula
    return (m f)

modifier = do
    o <- lexeme (oneOf "?^=/*")
    case o of
        '?' -> return What
        '^' -> return S
        '=' -> return Eq
        '/' -> return Slash
        '*' -> return Nock

-- Lexer
lexer      = T.makeTokenParser haskellStyle
lexeme     = T.lexeme lexer
integer    = T.integer lexer
brackets   = T.brackets lexer
identifier = T.identifier lexer
whiteSpace = T.whiteSpace lexer
