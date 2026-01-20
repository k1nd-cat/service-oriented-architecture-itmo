package ru.itmo.soa.oscar.web.soap;

import jakarta.jws.WebMethod;
import jakarta.jws.WebParam;
import jakarta.jws.WebResult;
import jakarta.jws.WebService;
import jakarta.xml.ws.BindingType;
import jakarta.xml.ws.soap.SOAPBinding;
import ru.itmo.soa.oscar.dto.DirectorInfo;
import ru.itmo.soa.oscar.dto.HumiliateResponse;
import ru.itmo.soa.oscar.dto.MovieGenre;
import ru.itmo.soa.oscar.service.OscarService;
import ru.itmo.soa.oscar.web.EJBLookupHelper;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebService(
    name = "OscarSoapService",
    targetNamespace = "http://soa.itmo.ru/oscar",
    serviceName = "OscarSoapService",
    portName = "OscarSoapServicePort"
)
@BindingType(SOAPBinding.SOAP12HTTP_BINDING)
public class OscarSoapService {
    
    private static final Logger log = Logger.getLogger(OscarSoapService.class.getName());
    private OscarService oscarService;
    
    public OscarSoapService() {
    }
    
    private OscarService getOscarService() {
        if (oscarService == null) {
            try {
                javax.naming.Context ctx = new javax.naming.InitialContext();
                oscarService = (OscarService) ctx.lookup("java:global/oscar-service/ru.itmo.soa-oscar-service-ejb-1.0.0/OscarServiceBean!ru.itmo.soa.oscar.service.OscarService");
            } catch (Exception e) {
                log.log(Level.SEVERE, "Failed to lookup OscarService", e);
                throw new RuntimeException("Failed to lookup OscarService: " + e.getMessage(), e);
            }
        }
        return oscarService;
    }
    
    @WebMethod(operationName = "getDirectorsWithoutOscars")
    @WebResult(name = "directors")
    public List<DirectorInfo> getDirectorsWithoutOscars() {
        try {
            log.info("SOAP: getDirectorsWithoutOscars called");
            List<DirectorInfo> directors = getOscarService().getDirectorsWithoutOscars();
            if (directors == null) {
                directors = new ArrayList<>();
            }
            log.info("SOAP: Successfully retrieved " + directors.size() + " directors");
            return directors;
        } catch (Exception e) {
            log.log(Level.SEVERE, "SOAP: Error getting directors without oscars", e);
            throw new RuntimeException("Failed to get directors without oscars: " + e.getMessage(), e);
        }
    }
    
    @WebMethod(operationName = "humiliateDirectorsByGenre")
    @WebResult(name = "humiliateResponse")
    public HumiliateResponse humiliateDirectorsByGenre(
            @WebParam(name = "genre") String genreStr) {
        try {
            log.info("SOAP: humiliateDirectorsByGenre called with genre: " + genreStr);
            
            MovieGenre genre;
            try {
                genre = MovieGenre.fromValue(genreStr);
            } catch (IllegalArgumentException e) {
                log.warning("SOAP: Invalid genre: " + genreStr);
                throw new RuntimeException("Invalid genre: " + genreStr + ". Valid values: COMEDY, ADVENTURE, TRAGEDY, SCIENCE_FICTION");
            }
            
            HumiliateResponse response = getOscarService().humiliateDirectorsByGenre(genre);
            log.info("SOAP: Successfully humiliated directors by genre " + genreStr);
            return response;
        } catch (RuntimeException e) {
            throw e;
        } catch (Exception e) {
            log.log(Level.SEVERE, "SOAP: Error humiliating directors by genre", e);
            throw new RuntimeException("Failed to humiliate directors by genre: " + e.getMessage(), e);
        }
    }
}
