package ru.itmo.soa.movie.util;

import java.util.ArrayList;
import java.util.List;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

public class ApiUtils {

    public static Pageable buildPageable(String sortString, int page, int size) {
        if (sortString == null || sortString.isEmpty()) {
            return PageRequest.of(page - 1, size);
        }

        List<Sort.Order> orders = new ArrayList<>();
        String[] sortPairs = sortString.split(";");

        for (String sortPair : sortPairs) {
            String[] parts = sortPair.split(",");
            if (parts.length == 2) {
                String field = parts[0].trim();
                String direction = parts[1].trim();

                Sort.Direction sortDirection = direction.equalsIgnoreCase("desc")
                        ? Sort.Direction.DESC
                        : Sort.Direction.ASC;

                orders.add(new Sort.Order(sortDirection, field));
            }
        }

        return PageRequest.of(page - 1, size, Sort.by(orders));
    }

}
