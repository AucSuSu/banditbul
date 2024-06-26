package org.banditbul.bandi.config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.banditbul.bandi.common.exception.EntityNotFoundException;
import org.banditbul.bandi.station.dto.StationSessionDto;
import org.banditbul.bandi.station.entity.Station;
import org.banditbul.bandi.station.repository.StationRepository;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.util.AntPathMatcher;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Arrays;
import java.util.Collections;

import static java.util.Objects.isNull;

@RequiredArgsConstructor
@Slf4j
public class UserAuthenticationFilter extends OncePerRequestFilter {

    private final StationRepository stationRepository;
    private final AntPathMatcher pathMatcher = new AntPathMatcher();
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {

        String path = request.getRequestURI();

        // /api/oauth 요청일 경우 필터의 나머지 로직을 건너뛰고 다음 필터로 진행
        if ("/api/login".equals(path)) {
            filterChain.doFilter(request, response);
            return;
        }

        if ("/api/signup".equals(path)) {
            filterChain.doFilter(request, response);
            return;
        }

        if (pathMatcher.match("/api/navigation/**",path)) {
            filterChain.doFilter(request, response);
            return;
        }
        if (pathMatcher.match("/api/sos/**",path)) {
            filterChain.doFilter(request, response);
            return;
        }
        if (pathMatcher.match("/api/stationinfo/**",path)) {
            filterChain.doFilter(request, response);
            return;
        }
        if (pathMatcher.match("/api/beacon/info/**",path)) {
            filterChain.doFilter(request, response);
            return;
        }
        if (pathMatcher.match("/socket/**",path)) {
            filterChain.doFilter(request, response);
            return;
        }

        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                // 특정 쿠키 이름을 찾습니다.
                System.out.println(cookie.getValue());
            }
        }
        log.info("userAuthenticationFilter 호출");

        HttpSession session = request.getSession(false); // 세션을 새로 생성하지 않음
        System.out.println("세션 있나? : " + session);
        if (session != null) {
            System.out.println(session);
            StationSessionDto user = (StationSessionDto) session.getAttribute("user");
            Station station = stationRepository.findById(user.getId()).orElseThrow(() -> new EntityNotFoundException("유저 정보가 없습니다."));
            if (station != null) {
                log.info("유저 정보 : " + station);
                GrantedAuthority authority = new SimpleGrantedAuthority("USER");
                Authentication authentication = new UsernamePasswordAuthenticationToken(station, null, Collections.singleton(authority));
                SecurityContextHolder.getContext().setAuthentication(authentication);
            }
        }
        filterChain.doFilter(request,response);
    }
}
