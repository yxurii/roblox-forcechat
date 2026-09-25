# Force Chat Studio v3.5 (Educational Script & Vulnerability PoC)

An advanced graphical interface (GUI) designed for **Roblox Luau environments** to demonstrate how client-side network manipulation interacting with insecure server-side architecture (such as unvalidated `RemoteEvents` or server-sided backdoors) can lead to chat spoofing.

> ⚠️ **Disclaimer:** This script is provided strictly for educational purposes, security research, and vulnerability testing within your own development environments. Do not use this tool maliciously or on games you do not have authorization to test.

## ⚡ Features

* **Custom UI Framework:** Sleek, modern interface using modern design components (`UICorner`, `UIStroke`, `UIGradient`) built fully via code.
* **Target Matching Engine:** Implements advanced partial and fuzzy name-matching logic to resolve player identities smoothly.
* **Dynamic Feedback:** Real-time state reporting and responsive UI layout animations during execution attempts.

## 🛠️ Technical Details

This tool operates as a client-side execution script. By default, its actions are fully local and will not replicate to other players. For global visibility, the environment must contain specific structural flaws:

* **Unsecured RemoteEvents:** Network architecture that takes a string argument from a client and passes it directly to server-authoritative chat functions without verifying the true identity of the sender.
* **Exposed Backdoors:** Untrusted third-party dependencies (`require()` scripts) running on the server that allow global arbitrary script injection.

## 🚀 Usage

1. Copy the code into your Luau execution environment or Roblox Studio command bar.
2. Run the script to display the graphical window.
3. Type the **Target Player's Name** (or display name) and the **Message Text**.
4. Click **Trigger Chat Bubble** to attempt execution.

## 🛡️ Defensive Remediation

If you are a developer looking to secure your game against unauthorized chat replication, implement strict server-side origin checks. Never trust client arguments implicitly:

```
-- Secure Server Implementation
RemoteEvent.OnServerEvent:Connect(function(sender, targetPlayer, message)
    -- Crucial Sanity Check: Ensure the sender is only controlling themselves
    if sender ~= targetPlayer then
        warn("Security Violation: " .. sender.Name .. " attempted to spoof " .. tostring(targetPlayer))
        return 
    end
    
    -- Proceed with validated execution
end)
```
