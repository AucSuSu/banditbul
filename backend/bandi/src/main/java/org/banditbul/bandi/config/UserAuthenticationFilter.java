package org.banditbul.bandi.config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.banditbul.bandi.common.exception.EntityNotFoundException;
import org.banditbul.bandi.station.dto.StationSessionDto;
import org.banditbul.bandi.station.entity.Station;
import org.banditbul.bandi.station.repository.StationRepository;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Collections;

import static java.util.Objects.isNull;

@RequiredArgsConstructor
public class UserAuthenticationFilter extends OncePerRequestFilter {

    private final StationRepository stationRepository;
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        HttpSession session = request.getSession(false); // 세션을 새로 생성하지 않음
        if (session != null) {
            StationSessionDto user = (StationSessionDto) session.getAttribute("user");
            Station station = stationRepository.findById(user.getId()).orElseThrow(() -> new EntityNotFoundException("유저 정보가 없습니다."));
            if (station != null) {
                GrantedAuthority authority = new SimpleGrantedAuthority("USER");
                Authentication authentication = new UsernamePasswordAuthenticationToken(station, null, Collections.singleton(authority));
                SecurityContextHolder.getContext().setAuthentication(authentication);
            }
        }
        filterChain.doFilter(request,response);
    }
}
