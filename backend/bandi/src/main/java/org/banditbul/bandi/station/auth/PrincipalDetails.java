package org.banditbul.bandi.station.auth;

import lombok.AllArgsConstructor;
import org.banditbul.bandi.station.entity.Station;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.ArrayList;
import java.util.Collection;

@AllArgsConstructor
public class PrincipalDetails implements UserDetails {

    private Station station;
    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        Collection<GrantedAuthority> collection = new ArrayList<>();
        collection.add(new GrantedAuthority() {
            @Override
            public String getAuthority() {
                return station.getRole();
            }
        });
        return collection;
    }

    @Override
    public String getPassword() {
        return station.getPassword();
    }

    @Override
    public String getUsername() {
        return station.getLoginId();
    }

    @Override
    public boolean isAccountNonExpired() {
        return false;
    }

    @Override
    public boolean isAccountNonLocked() {
        return false;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return false;
    }

    @Override
    public boolean isEnabled() {
        return false;
    }
}
