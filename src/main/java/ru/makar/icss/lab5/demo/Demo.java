package ru.makar.icss.lab5.demo;

import org.xml.sax.SAXException;

import javax.xml.XMLConstants;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;
import javax.xml.transform.*;
import javax.xml.transform.stax.StAXSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

public class Demo {
    public void run() throws TransformerConfigurationException {
        File xml = new File("src/main/resources/xml/sample-data.xml");
        File xsd = new File("src/main/resources/xsd/schema.xsd");
        File xsl = new File("src/main/resources/xsl/transform.xsl");

        System.out.print("Validate xml...");
        try (BufferedInputStream stream = new BufferedInputStream(new FileInputStream(xml))) {
            XMLStreamReader reader = XMLInputFactory.newInstance().createXMLStreamReader(stream);
            SchemaFactory schemaFactory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
            Schema schema = schemaFactory.newSchema(xsd);
            Validator validator = schema.newValidator();
            validator.validate(new StAXSource(reader));
            System.out.println("ok");
        } catch (SAXException saxException) {
            String message = saxException.getMessage();
            message = message.substring(message.indexOf(';') + 1).trim();
            System.err.println("error\n" + message);
        } catch (XMLStreamException | IOException e) {
            System.err.println("error");
        }

        System.out.println("Prepare XSLT transformer...");
        TransformerFactory factory = TransformerFactory.newInstance();
        factory.setErrorListener(new CustomErrorListener());
        Source xslt = new StreamSource(xsl);
        Transformer transformer = factory.newTransformer(xslt);
        System.out.println("Transforming...");
        Source text = new StreamSource(xml);
        try {
            transformer.transform(text, new StreamResult(new File("report.html")));
            System.out.println("Complete");
        } catch (TransformerException e) {
            System.err.println("Fail: " + e.getMessageAndLocation());
        }
    }
}
