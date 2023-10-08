"""TEST THINGS OUT IN THIS FILE"""
import sounddevice as sd
default_input_id, _ = sd.default.device
channels = sd.query_devices()[default_input_id]['max_input_channels']
print(channels)