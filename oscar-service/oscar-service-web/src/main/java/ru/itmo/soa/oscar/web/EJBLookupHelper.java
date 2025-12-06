package ru.itmo.soa.oscar.web;

import ru.itmo.soa.oscar.service.OscarService;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class EJBLookupHelper {

    private static final Logger log = Logger.getLogger(EJBLookupHelper.class.getName());

    private static final String OSCAR_SERVICE_JNDI = 
        "java:global/oscar-service/ru.itmo.soa-oscar-service-ejb-1.0.0/OscarServiceBean!ru.itmo.soa.oscar.service.OscarService";

    public static OscarService lookupRemoteOscarService() {
        Context ctx = null;
        try {
            ctx = new InitialContext();
            OscarService service = (OscarService) ctx.lookup(OSCAR_SERVICE_JNDI);
            return service;
        } catch (NamingException e) {
            throw new RuntimeException("Failed to lookup remote EJB", e);
        } finally {
            if (ctx != null) {
                try {
                    ctx.close();
                } catch (NamingException e) {
                    log.log(Level.WARNING, "Failed to close context", e);
                }
            }
        }
    }
}
