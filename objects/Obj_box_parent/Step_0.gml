if (moving)
{
    if (queue_dx != 0) {
        var sx = clamp(queue_dx, -move_speed, move_speed);
        x      += sx;
        queue_dx -= sx;
    }
    if (queue_dy != 0) {
        var sy = clamp(queue_dy, -move_speed, move_speed);
        y      += sy;
        queue_dy -= sy;
    }
    if (queue_dx == 0 && queue_dy == 0) moving = false;
}
