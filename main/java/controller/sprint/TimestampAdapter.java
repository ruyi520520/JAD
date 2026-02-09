/*=====================================
    Author: Huang Ruyi
    Date: 9/2/2026
    Description: ST0510/JAD project 2
====================================== */
package controller.sprint;

import jakarta.json.bind.adapter.JsonbAdapter;
import java.sql.Timestamp;
import java.time.OffsetDateTime;
import java.time.Instant;

public class TimestampAdapter implements JsonbAdapter<Timestamp, String> {

    @Override
    public String adaptToJson(Timestamp obj) {
        return obj == null ? null : obj.toInstant().toString();
    }

    @Override
    public Timestamp adaptFromJson(String obj) {
        if (obj == null || obj.isBlank()) return null;

        Instant instant = OffsetDateTime.parse(obj).toInstant();
        return Timestamp.from(instant);
    }
}
