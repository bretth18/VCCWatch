//
//  DataDisplay.swift
//  VCCWatch
//
//  Created by Brett Henderson on 9/28/15.
//  Copyright © 2015 Brett Henderson. All rights reserved.
//

import Foundation
import WatchKit
import NetworkExtension
import JavaScriptCore
import ButterKnifeFramework


public class dataDisplayActivity: VaporizerUpdateListener{
    
    @view(R.id.intro_text)
    TextView introText;
    
    //TOAST NOT IMPLEMENTED IN WATCHOS 2
    private LoadToast loadToast;
    
    @OnClick(R.id.led)
    void ledClick() {
        final boolean isUnkownOrNotBright = getApp().getVaporizerCommunicator().getData().ledPercentage == null ||
            getApp().getVaporizerCommunicator().getData().ledPercentage == 0;
    getApp().getVaporizerCommunicator().setLEDPercentageDialog(this, getApp().getVaporizerCommunicator().setLEDBrightness(isUnknownOrNotBright ? 100 : 0);
    }
    
    
    
    @onLongClick(R.id.led)
    boolean onLEDLongClick() {
    ChangeDialogs.showLEDPercentageDialog(this, getApp().getVaporizerCommunicator());
    return true;
    }
    
    @onClick({R.id.temperature, R.id.temperatureSetPoint, R.id.tempBoost})
    void onTemperatureClick() {
    changeDialogs.showTemperatureDialog(this, getApp().getVaporizerCommunicator());
    
    }
    
    @InjectView(R.id.battery)
    TextView battery;
    
    @InjectView(R.id.temperature)
    TextView temperature;
    
    @InjectView(R.id.temperatureSetPoint)
    TextView temperatureSetPoint;
    
    @InjectView(R.id.tempBoost)
    TextView tempBoost;
    
    @InjectView(R.id.led)
    TextView led;
    //FAM INJECTION INCOMING
    @InjectView(R.id.fam)
    FloatingActionsMenu fam;
    
    
    
    //ON FAM CLICk
    @OnClick(R.id.fab)
    void onFAMClick() {
    fam.toggle();
    
    }
    
    //for when the collapses
    @OnClick(R.id.fab_action_edit_boost)
    void on editBoostClick() {
    ChangeDialogs.setBooster(this, getApp().getVaporizerCommunicator()):
    fam.collapse
    }
    
    @OnClick(R.id.fab_action_edit_settemp)
    void editSetTempClick() {
    ChangeDialogs.showTemperatureDialog(this, getApp().getVaporizerCommunicator());
    fam.collapse();
    
    }
    
    @OnClick(R.id.fab_action_edit_led)
    void editLEDClick() {
    ChangeDialogs.showLEDPercentageDialog(this, getApp().getVaporizerCommunicator());
    fam.collapse();
    }
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    
    setContentView(R.layout.activity_main);
    ButterKnife.inject(this);
    
    AppRate.with(this).retryPolicy(RetryPolicy.EXPONENTIAL).initialLaunchCount(5).checkAndShow();
    
    //Toast not implemented warning
    loadToast = new LoadToast(this);
    
    if (!TraceDroidEmailSender.sendStackTraces("bretth18@gmail.com",this) && !getApp().getVaporizerCommunicator().getData().hasData()) {
            loadToast.setText("Searching for Crafty Vaporizer");
            loadToast.show();
    }
    
    @override
    public void onResume() {
    super.onResume();
    if(!getApp().getVaporizerCommunicator().isBluetoothAvailable()) {
    new Handler().postDelayed(new Runnable() {
        @Override
    public void run() {
    Toast.makeText(DataDisplayActivity.this, "Failed to scan for device - no Bluetooth Available". Toast.LENGTH_LONG).show();
    loadToast.error();
    }, 1000);
    
    else {
    getApp().getVaporizerCommunicator().setUpdateListener(this);
    
    }
    
    onUpdate(getApp().getVaporizerComunicator().getData());
    }
    
    private App getApp() {
    return (App) getApplication();
    
    }
    
    @override
    public bool onOptionsitemSelected(final Menuitem item) {
    switch (item.getItemId()) {
        case R.id.action_settings:
        startActivity(new Intent(this, SettingsActivity.class));
            break;
        case R.id.action_help:
    new AlertDialog.builder(this).setView(new HelpViewProvider().getView(this)).setTitle("Information").setPositiveButton("OK", null).show();
    break;
    
    }
    
    return super.onOptionsItemSelected(item);
    }
    
    @override
    public void onUpdate(final VaporizerData data) {
    runOnUiThread(new Runnable() {
        @override
    public void run() {
    if(introText.getVisibility() == VISIBILE) {
        introText.setVisibility(GONE);
        loadToast.success();
    } else {
    introText.setText(Html.fromhHtml(getString(R.string.intro_text)));
    introText.setMovementMethod(new LinkMovementMethod());
    
    }
    }
    
    battery.setText((data.batteryPercentage == null ? "?" : "" + data.batteryPercentage) + "%");
    final Settings settings = getApp().getSettings();
    temperature.setText(TemperatureFormatter.Compainion.getFormattedTemp(settings, data.currentTemperature, true) + " / ");
    
    
    }
    }
    }
    }
    
    }
    }
    }
    }
    }
    }
    }
    
    
    
    }
    }
}