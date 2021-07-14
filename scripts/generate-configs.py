#!/usr/bin/env python3

import os
import sys
import getopt
from jproperties import Properties

"""
Base Configuration Generator
"""


class GenerateConfig:

    def __init__(self, config_prefix, target_config_file, default_configs):
        self.config_prefix = config_prefix + "_"
        self.config_name = target_config_file
        self.default_configs = default_configs
        self.key_overrides = {}
        self.key_excludes = []

        self.p = Properties()
        with open(default_configs, "rb") as f:
            self.p.load(f, "utf-8")

    def set_key_overrides(self, overrides):
        self.key_overrides = overrides

    def add_key_override(self, target_key, special_key):
        self.key_overrides.__setitem__(target_key, special_key)

    def remove_key_override(self, target_key):
        self.key_overrides.pop(target_key, None)

    def set_excluded_keys(self, keys_to_exclude):
        self.key_excludes = keys_to_exclude

    # Capture Properties from Environment variables
    def capture_properties(self):

        environment_vars = os.environ.keys()
        environment_items = os.environ

        for key in environment_vars:
            if key.startswith(self.config_prefix):
                value = environment_items.get(key)

                # Strip out characters we don't need
                # Clean up and prepare for final capture
                property_key = key.replace(self.config_prefix, "", 1)
                property_key = property_key.replace("_", ".")
                property_key = property_key.lower()

                # replace special key substitution here if applicable
                if self.key_overrides.keys().__contains__(property_key):
                    replacement_key = self.key_overrides.get(property_key)
                    property_key = replacement_key

                if property_key in self.key_excludes:
                    continue

                # Set the property from the environment variable
                self.p.__setitem__(property_key, value)

    def save_properties(self):

        with open(self.config_name, "wb") as f:
            self.p.store(f, initial_comments=" Auto-generated Properties File", encoding="iso-8859-1",
                         strict=True, strip_meta=True)

    def print_properties(self):

        for key in self.p.keys():
            value = self.p.get(key)
            print(key, "->", value[0])

    def debug_environment_vars(self):

        environment_vars = os.environ.keys()
        environment_items = os.environ

        for key in environment_vars:
            print(key, "->", environment_items.get(key))
            print(key.startswith(self.config_prefix))

    def save_config_file_contents(self, filepath, contents):

        file = open(filepath, "w")
        file.write(contents)
        file.close()

        print("Closing config file for " + self.config_prefix)


# Used to generate Zookeeper Configuration files
class GenerateZookeeperConfigs(GenerateConfig):

    def __init__(self, target_config_file, default_configs):
        super().__init__("ZOOKEEPER", target_config_file, default_configs)


# Used to generate Kafka Broker Configuration files
class GenerateBrokerConfigs(GenerateConfig):

    def __init__(self, target_config_file, default_configs):
        super().__init__("KAFKA", target_config_file, default_configs)


# Used to generate Kafka Connect Configuration files
class GenerateConnectConfigs(GenerateConfig):

    def __init__(self, target_config_file, default_configs):
        super().__init__("CONNECT", target_config_file, default_configs)


def display_help():
    print("")
    print(str(sys.argv))
    print("")
    print('./generate-configs.py -c <command> -t <target_config_file> -d <default_configs_file>')
    print("Command is one of: ZOOKEEPER, KAFKA, CONNECT")
    print("Target config file is the final config file that needs to be generated")
    print("Default config is the initial config with the default values that can be overwritten by environment vars")
    print("Example: ./generate-configs.py -c ZOOKEEPER -t z.props -d zookeeper.default.properties")
    print("Example: ./generate-configs.py -c KAFKA -t broker.properties -d kafka.default.properties")
    print("")

    sys.exit(2)


def process_zookeeper_setup(target_properties_file, default_properties_file):
    generator = GenerateZookeeperConfigs(target_properties_file, default_properties_file)

    # https://zookeeper.apache.org/doc/r3.4.9/zookeeperAdmin.html#sc_configuration
    key_overrides = {
        "tick.time": "tickTime",
        "data.dir": "dataDir",
        "client.port": "clientPort",
        "init.limit": "initLimit",
        "sync.limit": "syncLimit",
        "global.outstanding.limit": "globalOutstandingLimit",
        "pre.alloc.size": "preAllocSize",
        "snap.count": "snapCount",
        "max.client.cnxns": "maxClientCnxns",
        "client.port.address": "clientPortAddress",
        "min.session.timeout": "minSessionTimeout",
        "max.session.timeout": "maxSessionTimeout",
        "leader.serves": "leaderServes",
        "cnx.timeout": "cnxTimeout",
        "autopurge.snap.retain.count": "autopurge.snapRetainCount",
        "autopurge.purge.interval": "autopurge.purgeInterval",
        "sync.enabled": "syncEnabled",
        "election.alg": "electionAlg"
    }

    generator.set_key_overrides(key_overrides)

    generator.add_key_override("data.log.dir", "dataLogDir")

    generator.capture_properties()
    generator.save_properties()
    generator.print_properties()


def process_broker_setup(target_properties_file, default_properties_file):
    generator = GenerateBrokerConfigs(target_properties_file, default_properties_file)

    keys_to_exclude = ['cluster.id']
    generator.set_excluded_keys(keys_to_exclude)

    generator.capture_properties()
    generator.save_properties()
    generator.print_properties()


def process_connect_setup(target_properties_file, default_properties_file):
    generator = GenerateConnectConfigs(target_properties_file, default_properties_file)
    generator.capture_properties()
    generator.save_properties()
    generator.print_properties()


global opts


# ./generate-configs.py -c ZOOKEEPER -t z.properties -d zookeeper.default.properties
# ./generate-configs.py -c KAFKA -t kafka.properties -d broker.default.properties
# ./generate-configs.py -c CONNECT -t connect.properties -d connect.default.properties
def main(argv):
    command_type = ""
    target_properties_file = ""
    default_properties_file = ""
    valid_commands = ["ZOOKEEPER", "KAFKA", "CONNECT"]

    opts = {}

    try:
        opts, args = getopt.getopt(argv, "ht:d:c:", ["target=", "default=", "command="])
    except getopt.GetoptError:
        display_help()

    if len(sys.argv) == 1:
        display_help()

    for opt, arg in opts:
        if opt == '-h':
            display_help()
        elif opt in ("-h", "--help"):
            display_help()
        elif opt in ("-t", "--target"):
            target_properties_file = arg
        elif opt in ("-d", "--default"):
            default_properties_file = arg
        elif opt in ("-c", "--command"):
            command_type = arg

    if not valid_commands.__contains__(command_type):
        print("")
        print("Command " + command_type + " is not valid")
        display_help()

    if len(target_properties_file) < 2:
        print("")
        print("Invalid target properties file")
        display_help()

    if len(default_properties_file) < 2:
        print("")
        print("Invalid default properties file")
        display_help()

    if command_type == "ZOOKEEPER":
        process_zookeeper_setup(target_properties_file, default_properties_file)

    elif command_type == "KAFKA":
        process_broker_setup(target_properties_file, default_properties_file)

    elif command_type == "CONNECT":
        process_connect_setup(target_properties_file, default_properties_file)


if __name__ == '__main__':
    main(sys.argv[1:])
