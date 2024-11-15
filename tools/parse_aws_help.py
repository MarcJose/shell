"""
Parse aws <service> help to retrieve a list of all AWS services and commands for it.
This can then be used for fzf in the shell.
"""

from typing import Dict, List
import subprocess

def get_aws_services() -> List[str]:
    """Parse AWS services from 'aws help' command output."""
    result = subprocess.run(
        ['aws', 'help'],
        capture_output=True,
        text=True,
        check=True
    )

    services = []
    in_services_section = False

    for line in result.stdout.split('\n'):
        line = line.strip()

        if 'AVAILABLE SERVICES' in line:
            in_services_section = True
            continue

        if in_services_section:
            if 'SEE ALSO' in line:
                break
            if line:
                service = line.replace('o ', '')
                service = service.replace('+\x08', '')
                service = service.strip()
                services.append(service)

    return sorted(services)

def get_service_commands(service: str) -> List[str]:
    """Get available commands for a service using aws help."""
    result = subprocess.run(
        ['aws', service, 'help'],
        capture_output=True,
        text=True,
        check=True
    )

    commands = []
    in_commands_section = False

    for line in result.stdout.split('\n'):
        line = line.strip()

        if 'AVAILABLE COMMANDS' in line:
            in_commands_section = True
            continue

        if in_commands_section:
            if service.upper() in line:
                break
            if line:
                command = line.replace('o ', '')
                command = command.replace('+\x08', '')
                command = command.strip()
                commands.append(command)
    return sorted(commands)

def get_all_service_commands() -> Dict[str, List[str]]:
    """Get commands for all AWS services."""
    services = get_aws_services()
    results = {}

    for service in services:
        try:
            commands = get_service_commands(service)
            if commands:
                results[service] = commands
                print(f"Processed {service}: {len(commands)} commands found")
        except subprocess.CalledProcessError as e:
            print(f"Error processing {service}: {e}")

    return results

if __name__ == '__main__':
    service_commands = get_all_service_commands()
    for service, commands in service_commands.items():
        for cmd in commands:
            print(f"{service}:{cmd}")
