<aura:application extends="force:slds" access="global">
    <ltng:require scripts=""  afterScriptsLoaded="{!c.scriptsLoaded}" />
    <aura:attribute name="isLoaded" type="Boolean" default="false"/>
    <aura:if isTrue="{!v.isLoaded}">
        <div class="printDoc">
            <c:OrderLineModal/>
        </div>
    </aura:if>
</aura:application>