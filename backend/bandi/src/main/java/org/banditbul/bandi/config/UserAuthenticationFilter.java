package org.banditbul.bandi.config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.banditbul.bandi.station.entity.Station;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Collections;

import static java.util.Objects.isNull;

public class UserAuthenticationFilter extends OncePerRequestFilter {

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        HttpSession session = request.getSession(false); // 세션을 새로 생성하지 않음
        if (session != null) {
            Station user = (Station) session.getAttribute("user");
            if (user != null) {
                GrantedAuthority authority = new SimpleGrantedAuthority("USER");
                Authentication authentication = new UsernamePasswordAuthenticationToken(user, null, Collections.singleton(authority));
                SecurityContextHolder.getContext().setAuthentication(authentication);
            }
        }
        filterChain.doFilter(request,response);
    }
}
