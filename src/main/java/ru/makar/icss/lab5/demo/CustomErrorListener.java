package ru.makar.icss.lab5.demo;

import javax.xml.transform.ErrorListener;
import javax.xml.transform.TransformerException;

class CustomErrorListener implements ErrorListener {
    @Override
    public void warning(TransformerException exception) {
        System.err.println("[WARN] " + exception.getMessageAndLocation());
    }

    @Override
    public void error(TransformerException exception) {
        System.err.println("[ERROR] " + exception.getMessageAndLocation());
    }

    @Override
    public void fatalError(TransformerException exception) {
        System.err.println("[FATAL] " + exception.getMessageAndLocation());
    }
}
