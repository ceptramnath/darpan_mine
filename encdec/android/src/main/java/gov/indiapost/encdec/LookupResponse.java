package gov.indiapost.encdec;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.io.Serializable;

public class LookupResponse implements Serializable
{
    private static final long serialVersionUID = 8260095980978686681L;
    private String subscriberId;
    private String country;
    private String city;
    private String domain;
    private String signingPublicKey;
    private String encrPublicKey;
    private String validFrom;
    private String validUntil;
    private String created;
    private String updated;
    private String type;
    private String subscriberUrl;
    private String brId;
    private String status;
    @JsonProperty("ukId")
    private String uniqueKeyId;

    public String getSubscriberId() {
        return this.subscriberId;
    }

    public String getCountry() {
        return this.country;
    }

    public String getCity() {
        return this.city;
    }

    public String getDomain() {
        return this.domain;
    }

    public String getSigningPublicKey() {
        return this.signingPublicKey;
    }

    public String getEncrPublicKey() {
        return this.encrPublicKey;
    }

    public String getValidFrom() {
        return this.validFrom;
    }

    public String getValidUntil() {
        return this.validUntil;
    }

    public String getCreated() {
        return this.created;
    }

    public String getUpdated() {
        return this.updated;
    }

    public String getType() {
        return this.type;
    }

    public String getSubscriberUrl() {
        return this.subscriberUrl;
    }

    public String getBrId() {
        return this.brId;
    }

    public String getStatus() {
        return this.status;
    }

    public String getUniqueKeyId() {
        return this.uniqueKeyId;
    }

    public void setSubscriberId(final String subscriberId) {
        this.subscriberId = subscriberId;
    }

    public void setCountry(final String country) {
        this.country = country;
    }

    public void setCity(final String city) {
        this.city = city;
    }

    public void setDomain(final String domain) {
        this.domain = domain;
    }

    public void setSigningPublicKey(final String signingPublicKey) {
        this.signingPublicKey = signingPublicKey;
    }

    public void setEncrPublicKey(final String encrPublicKey) {
        this.encrPublicKey = encrPublicKey;
    }

    public void setValidFrom(final String validFrom) {
        this.validFrom = validFrom;
    }

    public void setValidUntil(final String validUntil) {
        this.validUntil = validUntil;
    }

    public void setCreated(final String created) {
        this.created = created;
    }

    public void setUpdated(final String updated) {
        this.updated = updated;
    }

    public void setType(final String type) {
        this.type = type;
    }

    public void setSubscriberUrl(final String subscriberUrl) {
        this.subscriberUrl = subscriberUrl;
    }

    public void setBrId(final String brId) {
        this.brId = brId;
    }

    public void setStatus(final String status) {
        this.status = status;
    }

    @JsonProperty("ukId")
    public void setUniqueKeyId(final String uniqueKeyId) {
        this.uniqueKeyId = uniqueKeyId;
    }

    @Override
    public boolean equals(final Object o) {
        if (o == this) {
            return true;
        }
        if (!(o instanceof LookupResponse)) {
            return false;
        }
        final LookupResponse other = (LookupResponse)o;
        if (!other.canEqual(this)) {
            return false;
        }
        final Object this$subscriberId = this.getSubscriberId();
        final Object other$subscriberId = other.getSubscriberId();
        Label_0065: {
            if (this$subscriberId == null) {
                if (other$subscriberId == null) {
                    break Label_0065;
                }
            }
            else if (this$subscriberId.equals(other$subscriberId)) {
                break Label_0065;
            }
            return false;
        }
        final Object this$country = this.getCountry();
        final Object other$country = other.getCountry();
        Label_0102: {
            if (this$country == null) {
                if (other$country == null) {
                    break Label_0102;
                }
            }
            else if (this$country.equals(other$country)) {
                break Label_0102;
            }
            return false;
        }
        final Object this$city = this.getCity();
        final Object other$city = other.getCity();
        Label_0139: {
            if (this$city == null) {
                if (other$city == null) {
                    break Label_0139;
                }
            }
            else if (this$city.equals(other$city)) {
                break Label_0139;
            }
            return false;
        }
        final Object this$domain = this.getDomain();
        final Object other$domain = other.getDomain();
        Label_0176: {
            if (this$domain == null) {
                if (other$domain == null) {
                    break Label_0176;
                }
            }
            else if (this$domain.equals(other$domain)) {
                break Label_0176;
            }
            return false;
        }
        final Object this$signingPublicKey = this.getSigningPublicKey();
        final Object other$signingPublicKey = other.getSigningPublicKey();
        Label_0213: {
            if (this$signingPublicKey == null) {
                if (other$signingPublicKey == null) {
                    break Label_0213;
                }
            }
            else if (this$signingPublicKey.equals(other$signingPublicKey)) {
                break Label_0213;
            }
            return false;
        }
        final Object this$encrPublicKey = this.getEncrPublicKey();
        final Object other$encrPublicKey = other.getEncrPublicKey();
        Label_0250: {
            if (this$encrPublicKey == null) {
                if (other$encrPublicKey == null) {
                    break Label_0250;
                }
            }
            else if (this$encrPublicKey.equals(other$encrPublicKey)) {
                break Label_0250;
            }
            return false;
        }
        final Object this$validFrom = this.getValidFrom();
        final Object other$validFrom = other.getValidFrom();
        Label_0287: {
            if (this$validFrom == null) {
                if (other$validFrom == null) {
                    break Label_0287;
                }
            }
            else if (this$validFrom.equals(other$validFrom)) {
                break Label_0287;
            }
            return false;
        }
        final Object this$validUntil = this.getValidUntil();
        final Object other$validUntil = other.getValidUntil();
        Label_0324: {
            if (this$validUntil == null) {
                if (other$validUntil == null) {
                    break Label_0324;
                }
            }
            else if (this$validUntil.equals(other$validUntil)) {
                break Label_0324;
            }
            return false;
        }
        final Object this$created = this.getCreated();
        final Object other$created = other.getCreated();
        Label_0361: {
            if (this$created == null) {
                if (other$created == null) {
                    break Label_0361;
                }
            }
            else if (this$created.equals(other$created)) {
                break Label_0361;
            }
            return false;
        }
        final Object this$updated = this.getUpdated();
        final Object other$updated = other.getUpdated();
        Label_0398: {
            if (this$updated == null) {
                if (other$updated == null) {
                    break Label_0398;
                }
            }
            else if (this$updated.equals(other$updated)) {
                break Label_0398;
            }
            return false;
        }
        final Object this$type = this.getType();
        final Object other$type = other.getType();
        Label_0435: {
            if (this$type == null) {
                if (other$type == null) {
                    break Label_0435;
                }
            }
            else if (this$type.equals(other$type)) {
                break Label_0435;
            }
            return false;
        }
        final Object this$subscriberUrl = this.getSubscriberUrl();
        final Object other$subscriberUrl = other.getSubscriberUrl();
        Label_0472: {
            if (this$subscriberUrl == null) {
                if (other$subscriberUrl == null) {
                    break Label_0472;
                }
            }
            else if (this$subscriberUrl.equals(other$subscriberUrl)) {
                break Label_0472;
            }
            return false;
        }
        final Object this$brId = this.getBrId();
        final Object other$brId = other.getBrId();
        Label_0509: {
            if (this$brId == null) {
                if (other$brId == null) {
                    break Label_0509;
                }
            }
            else if (this$brId.equals(other$brId)) {
                break Label_0509;
            }
            return false;
        }
        final Object this$status = this.getStatus();
        final Object other$status = other.getStatus();
        Label_0546: {
            if (this$status == null) {
                if (other$status == null) {
                    break Label_0546;
                }
            }
            else if (this$status.equals(other$status)) {
                break Label_0546;
            }
            return false;
        }
        final Object this$uniqueKeyId = this.getUniqueKeyId();
        final Object other$uniqueKeyId = other.getUniqueKeyId();
        if (this$uniqueKeyId == null) {
            if (other$uniqueKeyId == null) {
                return true;
            }
        }
        else if (this$uniqueKeyId.equals(other$uniqueKeyId)) {
            return true;
        }
        return false;
    }

    protected boolean canEqual(final Object other) {
        return other instanceof LookupResponse;
    }

    @Override
    public int hashCode() {
        final int PRIME = 59;
        int result = 1;
        final Object $subscriberId = this.getSubscriberId();
        result = result * 59 + (($subscriberId == null) ? 43 : $subscriberId.hashCode());
        final Object $country = this.getCountry();
        result = result * 59 + (($country == null) ? 43 : $country.hashCode());
        final Object $city = this.getCity();
        result = result * 59 + (($city == null) ? 43 : $city.hashCode());
        final Object $domain = this.getDomain();
        result = result * 59 + (($domain == null) ? 43 : $domain.hashCode());
        final Object $signingPublicKey = this.getSigningPublicKey();
        result = result * 59 + (($signingPublicKey == null) ? 43 : $signingPublicKey.hashCode());
        final Object $encrPublicKey = this.getEncrPublicKey();
        result = result * 59 + (($encrPublicKey == null) ? 43 : $encrPublicKey.hashCode());
        final Object $validFrom = this.getValidFrom();
        result = result * 59 + (($validFrom == null) ? 43 : $validFrom.hashCode());
        final Object $validUntil = this.getValidUntil();
        result = result * 59 + (($validUntil == null) ? 43 : $validUntil.hashCode());
        final Object $created = this.getCreated();
        result = result * 59 + (($created == null) ? 43 : $created.hashCode());
        final Object $updated = this.getUpdated();
        result = result * 59 + (($updated == null) ? 43 : $updated.hashCode());
        final Object $type = this.getType();
        result = result * 59 + (($type == null) ? 43 : $type.hashCode());
        final Object $subscriberUrl = this.getSubscriberUrl();
        result = result * 59 + (($subscriberUrl == null) ? 43 : $subscriberUrl.hashCode());
        final Object $brId = this.getBrId();
        result = result * 59 + (($brId == null) ? 43 : $brId.hashCode());
        final Object $status = this.getStatus();
        result = result * 59 + (($status == null) ? 43 : $status.hashCode());
        final Object $uniqueKeyId = this.getUniqueKeyId();
        result = result * 59 + (($uniqueKeyId == null) ? 43 : $uniqueKeyId.hashCode());
        return result;
    }

    @Override
    public String toString() {
        return "LookupResponse(subscriberId=" + this.getSubscriberId() + ", country=" + this.getCountry() + ", city=" + this.getCity() + ", domain=" + this.getDomain() + ", signingPublicKey=" + this.getSigningPublicKey() + ", encrPublicKey=" + this.getEncrPublicKey() + ", validFrom=" + this.getValidFrom() + ", validUntil=" + this.getValidUntil() + ", created=" + this.getCreated() + ", updated=" + this.getUpdated() + ", type=" + this.getType() + ", subscriberUrl=" + this.getSubscriberUrl() + ", brId=" + this.getBrId() + ", status=" + this.getStatus() + ", uniqueKeyId=" + this.getUniqueKeyId() + ")";
    }
}
