import org.antlr.runtime.*;
import org.antlr.runtime.tree.*;
import org.antlr.stringtemplate.*;
import java.io.*;

public class calc {
    public static void main(String[] args) throws Exception {
		FileReader groupFileR = new FileReader("calcTree.stg");
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
        // begin parsing at rule r
        calcParser.calc_return r = parser.calc();
        CommonTree t = (CommonTree)r.getTree();
        // Walk resulting tree; create treenode stream first
        CommonTreeNodeStream nodes = new CommonTreeNodeStream(t);
        // AST nodes have payloads that point into token stream
        nodes.setTokenStream(tokens);
        // Create a tree Walker attached to the nodes stream
        calcTree walker = new calcTree(nodes);
		// use loaded templates
        walker.setTemplateLib(templates);
        System.out.println(walker.calc());
    }
}
