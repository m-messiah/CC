import org.antlr.runtime.*;

public class calc {
    public static void main(String[] args) throws Exception {
        ANTLRInputStream input = new ANTLRInputStream(System.in);
        calcLexer lexer = new calcLexer(input);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        calcParser parser = new calcParser(tokens);
        parser.calc();
    }
}




