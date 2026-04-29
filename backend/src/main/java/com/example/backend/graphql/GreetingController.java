package com.example.backend.graphql;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;

@Controller
public class GreetingController {

    @QueryMapping
    public String hello(@Argument String name) {
        if (name == null || name.isBlank()) {
            return "Hello from Java GraphQL backend!";
        }
        return "Hello, " + name + "!";
    }

    @QueryMapping
    public Viewer me(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return new Viewer("anonymous", false, List.of());
        }

        List<String> roles = authentication.getAuthorities().stream()
                .map(grantedAuthority -> grantedAuthority.getAuthority())
                .collect(Collectors.toList());

        return new Viewer(authentication.getName(), true, roles);
    }

    public record Viewer(String username, boolean authenticated, List<String> roles) {
    }
}
