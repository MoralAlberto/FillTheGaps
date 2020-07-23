import SwiftUI

struct WeekendView: ViewModifier {
    
    let isWeekend: Bool
    
    func body(content: Content) -> some View {
        content.background(isWeekend ? Color(UIColor.lightGray) : Color.white)
    }
}

extension View {
    func addWeekendStyle(isWeekend: Bool) -> some View {
        self.modifier(WeekendView(isWeekend: isWeekend))
    }
}
