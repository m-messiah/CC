import org.antlr.runtime.*;
import org.antlr.stringtemplate.*;
import java.io.*;

public class Main {
    public static void main(String[] args) throws Exception {
        // load template
        FileReader groupFileR = new FileReader("calc.stg");
        StringTemplateGroup templates = new StringTemplateGroup(groupFileR);
        groupFileR.close();

        // create a CharStream that reads from standard input
        ANTLRInputStream input = new ANTLRInputStream(System.in);
        // create a lexer that feeds off of input CharStream
        calcLexer lexer = new calcLexer(input);
        // create a buffer of tokens pulled from the lexer
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        // create a parser that feeds off the tokens buffer
        calcParser parser = new calcParser(tokens);
        // use loaded templates
        parser.setTemplateLib(templates);
        // begin parsing at rule r
        calcParser.input_return r = parser.input();

        // output stuff
        StringTemplate output = (StringTemplate)r.getTemplate();
        System.out.println(output.toString());
    }
}
