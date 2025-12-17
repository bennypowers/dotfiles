- when making changes to quickshell configuration, don't kill the quickshell process or restart the service - it automatically reloads

## TODO: Migrate to Built-in PolkitAgent (when Quickshell ≥0.2.2 available)

**Version Requirement**: Quickshell ≥0.2.2 (currently in master, waiting for Gentoo ebuild)

### Migration Overview

Replace custom quickshell-polkit-agent (qpa) C++ implementation with built-in `Quickshell.Services.Polkit.PolkitAgent`.

**Code reduction**: 2,608 lines → ~50-100 lines QML (96% reduction)

### Key Philosophy: "Pass Through to PAM"

Don't reimplement features - wire up what PAM/AuthFlow already provides:

- **Error messages**: Display `AuthFlow.supplementaryMessage` directly (no custom generation)
- **State tracking**: Use reactive properties (`isActive`, `isResponseRequired`, `failed`, etc.) instead of 9-state enum
- **FIDO detection**: Parse PAM prompt text (`inputPrompt`) or just show verbatim (no `lsusb` needed)
- **Retry counting**: Optional - simple counter variable or remove (trust PAM faillock)
- **Concurrent sessions**: YAGNI - Quickshell assumes single session via `agent.flow`

### Files to Modify

**Delete**:
- `PolkitSocketClient.qml` (136 lines - IPC client, no longer needed)
- `/home/bennyp/Developer/quickshell-polkit-agent/` (entire C++ project, 2,472 lines)
- `~/.config/systemd/user/quickshell-polkit-agent.service` (systemd service)

**Replace**:
- `PolkitAuth.qml` (657 lines → ~50-100 lines minimal implementation)

**Update**:
- `shell.qml` (swap `PolkitSocketClient` for `PolkitAgent`)

### Minimal Implementation Pattern

```qml
import Quickshell.Services.Polkit

PolkitAgent {
    id: agent

    WlrLayershell {
        visible: agent.isActive

        // Main message from polkit
        Text { text: agent.flow.message }

        // PAM errors/info (pass-through!)
        Text {
            text: agent.flow.supplementaryMessage
            color: agent.flow.supplementaryIsError ? "red" : "blue"
            visible: agent.flow.supplementaryMessage.length > 0
        }

        // PAM prompt (shows "Password:", "Insert U2F device", etc.)
        Text { text: agent.flow.inputPrompt }

        // Input field (appears when PAM requests input)
        TextField {
            visible: agent.flow.isResponseRequired
            echoMode: agent.flow.responseVisible ? TextInput.Normal : TextInput.Password
            onAccepted: agent.flow.submit(text)
        }

        Button {
            text: "Cancel"
            onClicked: agent.flow.cancelAuthenticationRequest()
        }
    }
}
```

### Estimated Effort

**Total**: 4-6 hours

1. Study AuthFlow API (1 hour)
2. Implement minimal QML (2 hours)
3. Add polish/styling (1 hour)
4. Testing (1-2 hours)

### Benefits

- ✅ 96% code reduction (2,608 → ~50-100 lines)
- ✅ Official Quickshell API (upstream support)
- ✅ No separate systemd service
- ✅ No C++ build dependency
- ✅ Simpler deployment (pure QML config)
- ✅ No IPC overhead (in-process)

### Costs

- ⚠️ Requires Quickshell ≥0.2.2 (not yet in Gentoo)
- ⚠️ 4-6 hours migration effort
- ⚠️ Loss of process isolation (agent runs in main quickshell)
- ⚠️ Loss of comprehensive unit tests (integration tests only)

### Testing Checklist

Before removing qpa, verify:

- [ ] Password authentication (no FIDO key)
- [ ] FIDO prompt → Enter → password fallback
- [ ] Wrong password → retry works
- [ ] Three wrong passwords → appropriate error
- [ ] Cancellation works (ESC key)
- [ ] Error messages display correctly
- [ ] PAM prompt text shows verbatim
- [ ] Echo flag respected (password hidden, FIDO visible)
- [ ] Works with: `run0`, `sudo`, `systemctl`, `nmcli`

### Migration Steps

1. **Verify version**: `quickshell --version` shows ≥0.2.2
2. **Backup current config**: `cp -r ~/.config/quickshell ~/.config/quickshell.backup`
3. **Implement new PolkitAuth.qml** using minimal pattern above
4. **Update shell.qml**: Replace `PolkitSocketClient` with `PolkitAgent`
5. **Delete PolkitSocketClient.qml**
6. **Test thoroughly** using checklist above
7. **Disable qpa service**: `systemctl --user disable --now quickshell-polkit-agent.service`
8. **Archive qpa**: `mv ~/Developer/quickshell-polkit-agent ~/Developer/quickshell-polkit-agent.old`
9. **Monitor for issues** for 1 week before permanent deletion

### Rollback Plan

If issues arise:

```bash
systemctl --user enable --now quickshell-polkit-agent.service
cp -r ~/.config/quickshell.backup/* ~/.config/quickshell/
systemctl --user restart quickshell.service
```

### References

- [PolkitAgent Documentation](https://quickshell.org/docs/master/types/Quickshell.Services.Polkit/PolkitAgent/)
- [AuthFlow Documentation](https://quickshell.org/docs/master/types/Quickshell.Services.Polkit/AuthFlow/)
- [Quickshell Changelog](https://quickshell.org/changelog/)