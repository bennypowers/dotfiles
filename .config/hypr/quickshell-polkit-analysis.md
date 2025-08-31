# Quickshell Polkit Wrapper Analysis

## Current System State

### Available Polkit Agents
- **hyprpolkitagent** (current): `/usr/libexec/hyprpolkitagent` - Qt-based, running as systemd user service
- **polkit-gnome-authentication-agent-1**: `/usr/libexec/polkit-gnome-authentication-agent-1` - GTK-based

### D-Bus Architecture

#### Authority Interface (`org.freedesktop.PolicyKit1`)
- **Service**: `org.freedesktop.PolicyKit1` (system bus)
- **Object**: `/org/freedesktop/PolicyKit1/Authority`
- **Key Methods**:
  - `RegisterAuthenticationAgent(subject, locale, object_path)`
  - `CheckAuthorization(subject, action_id, details, flags, cancellation_id)`
  - `AuthenticationAgentResponse(cookie, identity)`

#### Authentication Agent Interface (Required for our wrapper)
- **Service**: Must be provided by authentication agent
- **Object Path**: Registered with polkit authority
- **Must Implement**: `org.freedesktop.PolicyKit1.AuthenticationAgent`

### Current Behavior Analysis
1. **Registration**: hyprpolkitagent registers as agent via D-Bus
2. **Auth Request**: polkitd calls agent when auth needed
3. **UI Display**: Agent shows Qt/QML dialog
4. **Response**: Agent sends credentials back to polkitd
5. **Result**: polkitd authorizes/denies the original request

## Wrapper Strategy

### Architecture
```
Command (sudo) → polkitd → Hidden Agent → Quickshell UI → User → Hidden Agent → polkitd
```

### Implementation Plan
1. **Hidden Backend**: Run existing agent without UI
2. **D-Bus Monitor**: Quickshell monitors polkit authority for auth requests  
3. **UI Intercept**: Show custom Quickshell dialog instead of agent UI
4. **Credential Bridge**: Pass user input to hidden agent
5. **Response Relay**: Forward agent response back through polkitd

### Security Benefits
- Zero custom authentication logic
- Proven polkit agent handles all security
- UI-only modifications reduce attack surface
- Fallback to original agent if wrapper fails

## Next Steps
1. Create Quickshell D-Bus interface for polkit monitoring
2. Test agent coordination between hidden backend and custom UI
3. Implement credential passing mechanism
4. Build unified lock screen + auth UI components