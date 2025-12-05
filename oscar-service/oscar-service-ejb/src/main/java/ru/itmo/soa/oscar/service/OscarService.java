package ru.itmo.soa.oscar.service;

import jakarta.ejb.Remote;
import ru.itmo.soa.oscar.dto.DirectorInfo;
import ru.itmo.soa.oscar.dto.HumiliateResponse;
import ru.itmo.soa.oscar.dto.MovieGenre;

import java.util.List;

@Remote
public interface OscarService {
    
    List<DirectorInfo> getDirectorsWithoutOscars() throws Exception;
    
    HumiliateResponse humiliateDirectorsByGenre(MovieGenre genre) throws Exception;
}

