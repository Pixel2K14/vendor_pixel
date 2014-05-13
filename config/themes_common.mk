# T-Mobile theme engine
PRODUCT_PACKAGES += \
       ThemeChooser \
       ThemeProvider

PRODUCT_COPY_FILES += \
       vendor/pixel/config/permissions/com.tmobile.software.themes.xml:system/etc/permissions/com.tmobile.software.themes.xml \
       vendor/pixel/config/permissions/org.cyanogenmod.theme.xml:system/etc/permissions/org.cyanogenmod.theme.xml
